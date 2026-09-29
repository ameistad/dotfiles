# etterglod colors for zsh-syntax-highlighting (lua/etterglod/palette.lua in etterglod.nvim).
# The plugin itself is sourced at the end of .zshrc; it keeps styles that are already set.
# Hex colors need a truecolor terminal (Ghostty, WezTerm); elsewhere map them to 256 colors.
[[ $COLORTERM == (truecolor|24bit) ]] || zmodload zsh/nearcolor
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES+=(
  command                        'fg=#80b028'
  builtin                        'fg=#80b028'
  alias                          'fg=#80b028'
  suffix-alias                   'fg=#80b028'
  global-alias                   'fg=#80b028'
  function                       'fg=#80b028'
  precommand                     'fg=#80b028,italic'
  hashed-command                 'fg=#80b028'
  reserved-word                  'fg=#d07e22'
  unknown-token                  'fg=#f44542'
  single-quoted-argument         'fg=#c9c26b'
  double-quoted-argument         'fg=#c9c26b'
  dollar-quoted-argument         'fg=#c9c26b'
  rc-quote                       'fg=#ebb579'
  back-dollar-quoted-argument    'fg=#ebb579'
  back-double-quoted-argument    'fg=#ebb579'
  dollar-double-quoted-argument  'fg=#ffcf22'
  back-quoted-argument           'fg=#ffcf22'
  command-substitution-delimiter 'fg=#ffcf22'
  process-substitution-delimiter 'fg=#ffcf22'
  arithmetic-expansion           'fg=#ffcf22'
  single-hyphen-option           'fg=#ebb579'
  double-hyphen-option           'fg=#ebb579'
  globbing                       'fg=#a177ef'
  history-expansion              'fg=#a177ef'
  commandseparator               'fg=#e1efff'
  redirection                    'fg=#e1efff'
  path                           'none'
  autodirectory                  'none'
  comment                        'fg=#8a877b,italic'
  assign                         'fg=#ececec'
  default                        'none'
)
