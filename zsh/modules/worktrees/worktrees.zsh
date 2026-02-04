_wt_root() { git rev-parse --show-toplevel 2>/dev/null || return 1; }
_wt_base() {
  local r
  r="$(_wt_root)" || return 1
  echo "$r/.worktrees"
}

wt-init() {
  local root
  root="$(_wt_root)" || { echo "not in a git repo"; return 1; }

  local cmd="$WT_AGENT_CMD"
  echo "current agent command: ${cmd:-<not set>}"
  vared -p "agent command: " cmd
  [[ -z "$cmd" ]] && { echo "aborted"; return 1; }

  local envfile="$root/.env"
  if [[ -f "$envfile" ]] && grep -q '^WT_AGENT_CMD=' "$envfile"; then
    sed -i '' "s|^WT_AGENT_CMD=.*|WT_AGENT_CMD=\"$cmd\"|" "$envfile"
  else
    echo "WT_AGENT_CMD=\"$cmd\"" >> "$envfile"
  fi
  export WT_AGENT_CMD="$cmd"
  echo "saved to $envfile"
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

  local f line key val
  for f in "${files[@]}"; do
    [[ -f "$f" ]] || continue
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "$line" || "$line" == \#* ]] && continue
      key="${line%%=*}"
      val="${line#*=}"
      val="${val%\"}"
      val="${val#\"}"
      export "$key=$val"
    done < "$f"
  done
}

wt-ls() {
  local base
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  [[ -d "$base" ]] || { echo "no worktrees directory"; return 1; }

  local -a slugs=("$base"/*(N/:t))
  [[ ${#slugs[@]} -eq 0 ]] && { echo "no worktrees"; return 0; }

  local slug branch
  local -a rows=()
  for slug in "${slugs[@]}"; do
    branch=$(git -C "$base/$slug" rev-parse --abbrev-ref HEAD 2>/dev/null) || continue
    if [[ "$branch" != "$slug" ]]; then
      rows+=("$slug	$branch")
    else
      rows+=("$slug")
    fi
  done

  printf '%s\n' "${rows[@]}" | column -t -s $'\t'
}

wt-rm() {
  local force=0
  [[ "$1" == "--force" ]] && { force=1; shift; }
  local slug="$1"
  [[ -z "$slug" ]] && { echo "usage: wt-rm [--force] <slug>"; return 2; }

  local base dir
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  dir="$base/$slug"
  [[ -d "$dir" ]] || { echo "worktree not found: $slug"; return 1; }

  if (( ! force )) && [[ -n $(git -C "$dir" status --porcelain 2>/dev/null) ]]; then
    echo "worktree $slug has uncommitted changes, use --force to remove"
    return 1
  fi

  git worktree remove --force "$dir" || return 1
  git worktree prune 2>/dev/null
}

wt-merge() {
  local slug="$1"
  [[ -z "$slug" ]] && { echo "usage: wt-merge <slug>"; return 2; }

  local base dir root branch
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  root="$(_wt_root)" || return 1
  dir="$base/$slug"
  [[ -d "$dir" ]] || { echo "worktree not found: $slug"; return 1; }

  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    echo "could not determine branch for $slug"; return 1
  }

  if [[ -n $(git -C "$dir" status --porcelain 2>/dev/null) ]]; then
    git -C "$dir" add -A || return 1
    git -C "$dir" commit -m "wt-merge: auto-commit changes from $slug" || return 1
  fi

  if git -C "$root" merge "$branch" 2>&1; then
    git worktree remove --force "$dir" || return 1
    git worktree prune 2>/dev/null
    git -C "$root" branch -d "$branch" 2>/dev/null
    echo "merged $branch and removed worktree $slug"
    return 0
  fi

  local conflict_files
  conflict_files=$(git -C "$root" diff --name-only --diff-filter=U 2>/dev/null)
  [[ -z "$conflict_files" ]] && return 1

  local file_list=""
  local file
  while IFS= read -r file; do
    file_list+="- $file"$'\n'
  done <<< "$conflict_files"

  echo ""
  echo "copy this prompt into your agent to resolve:"
  echo "---"
  cat <<EOF
Resolve the merge conflicts in this repository. I was merging branch '$branch' (worktree '$slug') into $(git -C "$root" rev-parse --abbrev-ref HEAD).

Conflicted files:
${file_list}
For each file, look at the conflict markers (<<<<<<< / ======= / >>>>>>>), understand the intent of both sides, and pick the correct resolution. Remove all conflict markers when done.

After resolving, stage the files with git add and run: git commit --no-edit

Then clean up the worktree:
  git worktree remove --force "$dir"
  git worktree prune
  git branch -d "$branch"
EOF
  echo "---"
}

wt-agent() {
  local slug="$1"
  [[ -z "$slug" ]] && { echo "usage: wt-agent <slug>"; return 2; }

  local base dir root
  base="$(_wt_base)" || { echo "not in a git repo"; return 1; }
  root="$(_wt_root)" || return 1

  wt-loadenv "$root"
  [[ -z "$WT_AGENT_CMD" ]] && { echo "WT_AGENT_CMD not set, run wt-init first"; return 1; }
  dir="$base/$slug"
  if [[ ! -d "$dir" ]]; then
    echo "creating worktree: $slug"
    local gitignore="$root/.gitignore"
    if ! grep -qxF '.worktrees' "$gitignore" 2>/dev/null; then
      echo '.worktrees' >> "$gitignore"
    fi
    mkdir -p "$base" || return 1
    git worktree prune 2>/dev/null
    if git show-ref --verify --quiet "refs/heads/$slug" 2>/dev/null; then
      git worktree add "$dir" "$slug" || return 1
    else
      git worktree add "$dir" || return 1
    fi
  fi

  local prev="$PWD"
  wt-loadenv "$dir"
  cd "$dir" || return 1

  local -a cmd
  cmd=(${=WT_AGENT_CMD})
  command "${cmd[@]}"

  cd "$prev" 2>/dev/null || cd "$root"
}
