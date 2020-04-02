# Print node_modules
# find . -name "node_modules" -type d -prune -print | xargs du -chs

# Delete
# find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;
