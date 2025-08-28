#!/usr/bin/env bash

set -e

echo "🚀 Setting up dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to create symlinks
link_file() {
    local src=$1
    local dst=$2

    if [ -h "$dst" ]; then
        echo "🔗 Removing existing symlink: $dst"
        rm "$dst"
    elif [ -f "$dst" ]; then
        echo "📋 Backing up existing file: $dst -> $dst.backup"
        mv "$dst" "$dst.backup"
    elif [ -d "$dst" ]; then
        echo "📋 Backing up existing directory: $dst -> $dst.backup"
        mv "$dst" "$dst.backup"
    fi

    echo "🔗 Linking $src -> $dst"
    ln -s "$src" "$dst"
}

# Function to create directory if it doesn't exist
ensure_dir() {
    if [ ! -d "$1" ]; then
        echo "📁 Creating directory: $1"
        mkdir -p "$1"
    fi
}

# Create necessary directories
ensure_dir "$HOME/.config"

# Link zsh configuration
echo "🐚 Installing zsh configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Link neovim configuration
if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
    echo "✏️  Installing neovim configuration..."
    link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# Check if .localrc exists, if not create a template
if [ ! -f "$HOME/.localrc" ]; then
    echo "📝 Creating .localrc template..."
    cat > "$HOME/.localrc" << EOF
# Local environment variables
export PATH="/opt/homebrew/bin:\$PATH"
export PROJECTS_DIRECTORY="\$HOME/Projects"

# Add your private environment variables here
# export GITHUB_TOKEN="your_token_here"
EOF
    echo "✏️  Please edit ~/.localrc to set your environment variables"
fi

echo "✅ Dotfiles setup complete!"
echo "🔄 Please restart your terminal or run: source ~/.zshrc"
echo "📝 Neovim config installed to ~/.config/nvim"
