# Go toolchain: Homebrew is already on PATH on macOS; /usr/local/go/bin is the Linux tarball location.
[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"
