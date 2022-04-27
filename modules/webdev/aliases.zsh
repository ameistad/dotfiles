alias bserver="browser-sync start --server --port 8080 --files \"*.html, *.css, css/*.css, *.js, js/*.js\""

check-redirect() {
    curl -v -L $1 2>&1 | grep -i "^< location:"
}
