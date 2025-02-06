alias git-clean="git branch | grep -v "main" | xargs git branch -D"
# move fast
alias mf="git add -A && git commit -m "-" && git push"

function gap() {
  git add -A && git commit -m "$*" && git push
}
