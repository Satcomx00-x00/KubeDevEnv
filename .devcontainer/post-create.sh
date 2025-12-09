#!/bin/bash

# Setup dotfiles
if [ -d "/home/vscode/.dotfiles_source" ]; then
    echo "Setting up dotfiles..."
    # Copy files, including hidden ones, overwriting existing
    cp -r /home/vscode/.dotfiles_source/. /home/vscode/
    echo "Dotfiles copied."
fi

# Print info
echo "Environment setup complete."
echo "Redis is available at host 'redis' port 6379."
echo "Postgres is available at host 'db' port 5432 (user: postgres, pass: postgrespassword, db: devdb)."
echo "Supabase CLI is installed. Run 'supabase init' to start a local stack."
