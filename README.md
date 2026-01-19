# KubeDevEnv

A development container environment for Kubernetes development with modern shell configurations.

## Features

- **Docker-in-Docker** for container development
- **Kubernetes tools**: kubectl, Helm, Minikube
- **Modern shell**: Zsh with Oh My Zsh and Powerlevel10k theme
- **Terminal multiplexer**: Zellij
- **Dotfiles management**: Chezmoi with custom dotfiles
- **Database tools**: PostgreSQL and Redis clients
- **Supabase CLI** for local development

## Getting Started

### Using with VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Clone this repository with submodules:
   ```bash
   git clone --recurse-submodules https://github.com/Satcomx00-x00/KubeDevEnv.git
   ```
3. Open in VS Code and click "Reopen in Container" when prompted

### Updating Submodules

To update the dotfiles submodule to the latest version:

```bash
git submodule update --remote .devcontainer/dotfiles
```

## Dotfiles

This project includes [dotfiles](https://github.com/Satcomx00-x00/dotfiles) as a submodule, managed by [chezmoi](https://www.chezmoi.io/). The dotfiles are automatically applied during container creation.

### Customizing Dotfiles

Edit `~/.config/chezmoi/chezmoi.toml` to personalize your configuration:

```toml
[data]
    name = "Your Name"
    email = "your.email@example.com"
    editor = "code"

[data.machine]
    type = "devcontainer"
```

Then reapply with:

```bash
chezmoi apply
```

## License

MIT License
