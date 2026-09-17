# EXTENDED_GLOB (config.zsh) makes `HEAD^` a glob; git does its own pathspec globbing.
alias git='noglob git'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'

# Delete every local branch except main/master and the current one. Asks first; -f skips.
git-clean() {
  local force=0 current
  [[ $1 == (-f|--force) ]] && force=1
  current=$(git symbolic-ref --short -q HEAD) || { echo "not on a branch"; return 1; }
  local -a branches
  branches=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads/)"})
  branches=(${branches:#(main|master|$current)})
  (( ${#branches} )) || { echo "nothing to clean"; return 0; }
  print -l "branches to delete:" "  ${^branches}"
  if (( ! force )); then
    read -q "?delete ${#branches} branch(es)? [y/N] " || { echo; return 1; }
    echo
  fi
  git branch -D "${branches[@]}"
}

# add everything, commit with the given message, push
gap() {
  git add -A && git commit -m "$*" && git push
}
