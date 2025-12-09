#!/bin/bash

# Setup dotfiles
if [ -d "$HOME/.dotfiles_source" ]; then
    echo "Setting up dotfiles..."
    # Copy files, including hidden ones, overwriting existing
    cp -r $HOME/.dotfiles_source/. $HOME/
    echo "Dotfiles copied."
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
