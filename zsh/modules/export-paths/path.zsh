# Add all exported paths that doesn't fit anywhere else here.

# Custom scripts directory
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# psql (Homebrew on Apple Silicon)
[[ -d /opt/homebrew/opt/libpq/bin ]] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
