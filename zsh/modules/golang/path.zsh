# Go binary (for go command itself)
export PATH=/usr/local/go/bin:$PATH

# Go tools and installed binaries (like gopls)
export PATH="$(go env GOPATH)/bin:$PATH"
