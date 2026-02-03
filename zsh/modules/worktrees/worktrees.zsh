: ${WT_AGENT_CMD:=codex}

_wt_root() { git rev-parse --show-toplevel 2>/dev/null || return 1; }
_wt_base() {
  local r
  r="$(_wt_root)" || return 1
  echo "$r/.worktrees"
}

wt-loadenv() {
  local dir="${1:-$PWD}"
  local root
  root="$(_wt_root)" || return 0
  local envname="${WT_ENV:-${NODE_ENV:-${ENV:-}}}"

  local -a files=(
    "$root/.env" "$root/.env.local"
  )
  [[ -n "$envname" ]] && files+=("$root/.env.$envname")

  files+=(
    "$dir/.env" "$dir/.env.local"
  )
  [[ -n "$envname" ]] && files+=("$dir/.env.$envname")

  set -a
  local f
  for f in "${files[@]}"; do
    [[ -f "$f" ]] && source "$f"
  done
  set +a
}

wt-ls() {
  local base
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  [[ -d "$base" ]] || { echo "no worktrees directory"; return 1; }

  local -a slugs=("$base"/*(/:t))
  [[ ${#slugs[@]} -eq 0 ]] && { echo "no worktrees"; return 0; }

  local slug branch state
  local -a rows=()
  for slug in "${slugs[@]}"; do
    branch=$(git -C "$base/$slug" rev-parse --abbrev-ref HEAD 2>/dev/null) || continue
    if [[ -n $(git -C "$base/$slug" status --porcelain 2>/dev/null) ]]; then
      state="dirty"
    else
      state="clean"
    fi
    if [[ "$branch" == "$slug" ]]; then
      rows+=("$slug		$state")
    else
      rows+=("$slug	$branch	$state")
    fi
  done

  printf '%s\n' "${rows[@]}" | column -t -s $'\t'
}

wt-rm() {
  local slug="$1"
  [[ -z "$slug" ]] && { echo "usage: wt-rm <slug>"; return 2; }

  local base dir
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  dir="$base/$slug"
  [[ -d "$dir" ]] || { echo "worktree not found: $slug"; return 1; }

  git worktree remove "$dir" || return 1
  git worktree prune 2>/dev/null
}

wt-agent() {
  local slug="$1"
  [[ -z "$slug" ]] && { echo "usage: wt-agent <slug>"; return 2; }

  local base dir
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  dir="$base/$slug"
  if [[ ! -d "$dir" ]]; then
    echo "missing worktree: $dir"
    echo "creating worktree for branch: $slug"
    local root
    root="$(_wt_root)" || return 1
    local gitignore="$root/.gitignore"
    if ! grep -qxF '.worktrees' "$gitignore" 2>/dev/null; then
      echo '.worktrees' >> "$gitignore"
    fi
    mkdir -p "$base" || return 1
    git worktree prune 2>/dev/null
    git worktree add "$dir" || return 1
  fi

  wt-loadenv "$dir"
  cd "$dir" || return 1

  local -a cmd
  cmd=(${=WT_AGENT_CMD})
  command "${cmd[@]}"
}
