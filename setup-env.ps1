<#
.SYNOPSIS
    Setup script for KubeDevEnv on Windows Host.
.DESCRIPTION
    Checks for required tools (Kubectl, Helm, Minikube, Docker) and offers to install them via Winget.
    Offers to deploy the Docker Compose stack (Redis, Postgres) and start Minikube.
.NOTES
    Run this script in PowerShell as Administrator for best results with installations.
#>

$ErrorActionPreference = "Stop"

function Write-Header {
    param ([string]$Text)
    Write-Host "`n=== $Text ===" -ForegroundColor Cyan
}

function Check-And-Install {
    param (
        [string]$Name,
        [string]$Command,
        [string]$WingetId
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Host "✅ $Name is installed." -ForegroundColor Green
    } else {
        Write-Host "❌ $Name is NOT installed." -ForegroundColor Red
        $response = Read-Host "   Do you want to install $Name using winget? (Y/N)"
        if ($response -eq 'Y' -or $response -eq 'y') {
            try {
                Write-Host "   Installing $Name..." -ForegroundColor Yellow
                winget install -e --id $WingetId
                Write-Host "   ✅ $Name installed successfully." -ForegroundColor Green
                Write-Host "   Note: You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
            } catch {
                Write-Error "   Failed to install $Name. Please install it manually."
            }
        }
    }
}

Write-Header "KubeDevEnv Setup (Windows)"

# 1. Check and Install Tools
Write-Host "`nChecking prerequisites..."
Check-And-Install -Name "Docker Desktop" -Command "docker" -WingetId "Docker.DockerDesktop"
Check-And-Install -Name "Kubectl" -Command "kubectl" -WingetId "Kubernetes.kubectl"
Check-And-Install -Name "Helm" -Command "helm" -WingetId "Helm.Helm"
Check-And-Install -Name "Minikube" -Command "minikube" -WingetId "Kubernetes.minikube"

# 2. Start Minikube
Write-Header "Minikube"
$startMinikube = Read-Host "Do you want to start Minikube? (Y/N)"
if ($startMinikube -eq 'Y' -or $startMinikube -eq 'y') {
    Write-Host "Starting Minikube..." -ForegroundColor Yellow
    
    # Clear existing Docker environment variables
    Remove-Item Env:\DOCKER_TLS_VERIFY -ErrorAction SilentlyContinue
    Remove-Item Env:\DOCKER_HOST -ErrorAction SilentlyContinue
    Remove-Item Env:\DOCKER_CERT_PATH -ErrorAction SilentlyContinue
    Remove-Item Env:\MINIKUBE_ACTIVE_DOCKERD -ErrorAction SilentlyContinue

    minikube start -p minikube-docker --driver=docker
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Minikube started!" -ForegroundColor Green
    } else {
        Write-Error "Failed to start Minikube."
    }
}

# 3. Deploy Docker Compose Stack in Minikube
Write-Header "Stack Deployment (Minikube)"
$deployStack = Read-Host "Do you want to deploy the Docker Compose stack to Minikube? (Y/N)"
if ($deployStack -eq 'Y' -or $deployStack -eq 'y') {
    if (Test-Path ".devcontainer/docker-compose.yml") {
        Write-Host "Configuring Docker environment for Minikube..." -ForegroundColor Yellow
        try {
            # Clear existing Docker environment variables to ensure Minikube command works
            Remove-Item Env:\DOCKER_TLS_VERIFY -ErrorAction SilentlyContinue
            Remove-Item Env:\DOCKER_HOST -ErrorAction SilentlyContinue
            Remove-Item Env:\DOCKER_CERT_PATH -ErrorAction SilentlyContinue
            Remove-Item Env:\MINIKUBE_ACTIVE_DOCKERD -ErrorAction SilentlyContinue

            # Configure Docker to use Minikube's daemon
            $minikubeEnv = minikube docker-env -p minikube-docker --shell powershell
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to get Minikube Docker environment."
            }
            $minikubeEnv | Invoke-Expression
            
            if (-not $env:DOCKER_HOST) {
                throw "Could not get Minikube Docker environment. Is Minikube running?"
            }

            Write-Host "Deploying dependencies (db, redis) to Minikube..." -ForegroundColor Yellow
            Write-Host "   Note: Skipping 'workspace' container as Windows bind mounts are not supported in Minikube." -ForegroundColor Gray
            docker compose -f .devcontainer/docker-compose.yml up -d db redis
            
            Write-Host "✅ Stack deployed to Minikube!" -ForegroundColor Green
            
            # Get Minikube IP for access info
            $minikubeIp = minikube ip -p minikube-docker
            Write-Host "   Redis: $minikubeIp:6379"
            Write-Host "   Postgres: $minikubeIp:5432"
        } catch {
            Write-Error "Failed to deploy stack. $_"
        }
    } else {
        Write-Error "docker-compose.yml not found in .devcontainer/"
    }
}

Write-Header "Setup Complete"
Write-Host "You can now open this folder in VS Code and use 'Reopen in Container'." -ForegroundColor Green
