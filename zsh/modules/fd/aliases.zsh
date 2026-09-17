# Debian/Ubuntu package the binary as `fdfind`.
if ! whence -p fd >/dev/null 2>&1 && whence -p fdfind >/dev/null 2>&1; then
  alias fd=fdfind
fi
