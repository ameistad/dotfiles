# Go tools and installed binaries (like gopls).
# `go env GOPATH` forks the toolchain on every shell; the default is $HOME/go.
# Set GOPATH in ~/.localrc if you use a custom one.
if command -v go >/dev/null 2>&1; then
  export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
fi
