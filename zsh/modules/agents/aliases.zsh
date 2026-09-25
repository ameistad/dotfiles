# Launch AI agents in full-access mode, with "<agent> · <dir>" as the tab title.
function _agent_title() {
  print -Pn "\e]2;$1 · %2~\a"
}

function cl() {
  _agent_title claude
  CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1 claude --dangerously-skip-permissions "$@"
}

function cx() {
  _agent_title codex
  codex --dangerously-bypass-approvals-and-sandbox "$@"
}
