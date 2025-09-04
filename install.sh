#!/usr/bin/env bash

set -e

echo "🚀 Installing dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to create symlinks
link_file() {
    local src="$1"
    local dest="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    # Remove existing file/symlink
    if [[ -L "$dest" ]]; then
        echo "🔗 Removing existing symlink: $dest"
        rm "$dest"
    elif [[ -f "$dest" ]]; then
        echo "📦 Backing up existing file: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    elif [[ -d "$dest" ]]; then
        echo "📦 Backing up existing directory: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Create symlink
    echo "🔗 Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Install zsh configuration
echo "Installing zsh configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Install neovim configuration
echo "Installing neovim configuration..."
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Install ghostty
echo "Installing ghostty configuration..."
link_file "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

# Install wezterm configuration
echo "Installing wezterm configuration..."
link_file "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

# Install root configuration files
echo "Installing root configuration files..."
# Enable globbing for hidden files
shopt -s dotglob
for file in "$DOTFILES_DIR/root"/*; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        # Skip .localrc - handled separately
        if [[ "$filename" != ".localrc" ]]; then
            link_file "$file" "$HOME/$filename"
        fi
    fi
done
# Disable dotglob to restore default behavior
shopt -u dotglob

# Create .localrc template if it doesn't exist
echo "📝 Setting up local environment..."
if [[ ! -f "$HOME/.localrc" ]]; then
    echo "📝 Creating .localrc template..."
    cat > "$HOME/.localrc" << 'EOF'
# Local environment variables
export PATH="/opt/homebrew/bin:$PATH"
export PROJECTS_DIRECTORY="$HOME/Projects"

# Add your private environment variables here
# export GITHUB_TOKEN="your_token_here"
EOF
    echo "✏️  Please edit ~/.localrc to set your environment variables"
else
    echo "⏭️  Skipping .localrc - file already exists"
fi

echo "✅ Dotfiles setup complete!"
echo "🔄 Please restart your terminal or run: source ~/.zshrc"
echo "📝 Neovim config installed to ~/.config/nvim"
