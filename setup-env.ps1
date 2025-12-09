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

# 2. Deploy Docker Compose Stack
Write-Header "Stack Deployment"
$deployStack = Read-Host "Do you want to deploy the Docker Compose stack (Redis, Postgres)? (Y/N)"
if ($deployStack -eq 'Y' -or $deployStack -eq 'y') {
    if (Test-Path ".devcontainer/docker-compose.yml") {
        Write-Host "Deploying stack..." -ForegroundColor Yellow
        try {
            docker compose -f .devcontainer/docker-compose.yml up -d
            Write-Host "✅ Stack deployed!" -ForegroundColor Green
            Write-Host "   Redis: localhost:6379"
            Write-Host "   Postgres: localhost:5432"
        } catch {
            Write-Error "Failed to deploy stack. Ensure Docker is running."
        }
    } else {
        Write-Error "docker-compose.yml not found in .devcontainer/"
    }
}

# 3. Start Minikube
Write-Header "Minikube"
$startMinikube = Read-Host "Do you want to start Minikube? (Y/N)"
if ($startMinikube -eq 'Y' -or $startMinikube -eq 'y') {
    Write-Host "Starting Minikube..." -ForegroundColor Yellow
    try {
        minikube start
        Write-Host "✅ Minikube started!" -ForegroundColor Green
    } catch {
        Write-Error "Failed to start Minikube."
    }
}

Write-Header "Setup Complete"
Write-Host "You can now open this folder in VS Code and use 'Reopen in Container'." -ForegroundColor Green
