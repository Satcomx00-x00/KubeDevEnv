#!/bin/bash

# Setup dotfiles using chezmoi
if [ -d "/tmp/dotfiles" ]; then
    echo "Setting up dotfiles with chezmoi..."
    
    # Initialize chezmoi with the dotfiles from the submodule
    if command -v chezmoi &> /dev/null; then
        # Copy dotfiles to chezmoi source directory
        mkdir -p "$HOME/.local/share/chezmoi"
        cp -r /tmp/dotfiles/. "$HOME/.local/share/chezmoi/"
        
        # Create default chezmoi config to avoid interactive prompts
        mkdir -p "$HOME/.config/chezmoi"
        if [ ! -f "$HOME/.config/chezmoi/chezmoi.toml" ]; then
            cat > "$HOME/.config/chezmoi/chezmoi.toml" << 'EOF'
[data]
    name = "Developer"
    email = "dev@example.com"
    editor = "code"

[data.machine]
    type = "devcontainer"
EOF
        fi
        
        # Apply dotfiles (non-interactive)
        chezmoi apply --force || echo "Chezmoi apply completed with some warnings"
        echo "Dotfiles applied via chezmoi."
    else
        echo "chezmoi not found, falling back to manual copy..."
        cp -r /tmp/dotfiles/home/. $HOME/ 2>/dev/null || true
    fi
else
    echo "No dotfiles found at /tmp/dotfiles, skipping dotfiles setup."
fi

# Setup Powerlevel10k
if [ -d "/usr/share/powerlevel10k" ]; then
    mkdir -p ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        ln -s /usr/share/powerlevel10k ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        echo "Powerlevel10k linked."
    fi
fi

# Print info
echo "Environment setup complete."
echo "Redis is available at host 'redis' port 6379."
echo "Postgres is available at host 'db' port 5432 (user: postgres, pass: postgrespassword, db: devdb)."
echo "Supabase CLI is installed. Run 'supabase init' to start a local stack."
