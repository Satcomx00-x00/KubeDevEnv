# KubeDevEnv - State of the Art Dev Environment

This is a fully configured Development Environment designed for VS Code Remote - Containers.

## Features

- **OS**: Microsoft Universal Image (Ubuntu-based)
- **Services**:
  - **Redis**: Available at `redis:6379`
  - **PostgreSQL**: Available at `db:5432` (User: `postgres`, Pass: `postgrespassword`, DB: `devdb`)
  - **Supabase**: CLI installed. Run `supabase init` and `supabase start` to launch a local stack.
- **Tools**:
  - `kubectl`, `helm`, `minikube` (via Docker-in-Docker)
  - `node`, `python`, `zsh`, `git`
  - `redis-tools`, `postgresql-client`
  - `zellij` (Terminal Multiplexer)
- **Dotfiles**: Automatically loads dotfiles from the `dotfiles/` directory in this repo.
  - Includes pre-configured `.zshrc` (Oh My Zsh), `.gitconfig`, and `zellij` config.

## Getting Started

1. **Prerequisites**:
   - Docker Desktop (Windows/Mac) or Docker Engine (Linux).
   - VS Code with "Dev Containers" extension.

2. **Open in Container**:
   - Open this folder in VS Code.
   - Click "Reopen in Container" when prompted, or use the Command Palette (`F1` -> `Dev Containers: Reopen in Container`).

3. **Usage**:
   - **Terminals**: The default shell is `zsh`.
   - **Databases**: Connect to Postgres using the "SQLTools" extension (pre-installed) or `psql`.
   - **Supabase**:
     ```bash
     supabase init
     supabase start
     ```
     *Note: Supabase runs its own stack (Postgres on 54322, etc.) so it won't conflict with the standalone Redis/Postgres services.*
   - **Minikube**:
     ```bash
     minikube start
     ```
     *Note: Running Minikube inside a container requires privileged mode, which is enabled.*

## Dotfiles

Place your dotfiles (e.g., `.zshrc`, `.gitconfig`, aliases) in the `dotfiles/` directory. They will be copied to `~` inside the container on creation.

## Windows Minikube Note

If you are running Minikube on Windows and want to connect to it from this container instead of running a nested Minikube:
1. Ensure your Windows `~/.kube/config` is mounted or copied.
2. Update the kubeconfig server URL to point to `host.docker.internal` instead of `127.0.0.1`.
