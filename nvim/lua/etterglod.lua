local M = {}

local colors = {
  -- Background colors
  bg = '#171717',
  bg_alt = '#272727',
  bg_highlight = '#303030',
  bg_visual = '#676b71',

  -- Foreground colors
  fg = '#c5c8c6',
  fg_alt = '#e9e9e9',
  fg_dim = '#b0b0b0',

  -- UI colors
  border = '#3655b5',
  cursor = '#c07020',
  line_nr = '#949494',
  indent_guide = '#505037',
  indent_guide_active = '#707057',

  -- Syntax colors
  comment = '#b6b4a9',
  constant = '#bd3a3a',
  string = '#c9c26b',
  number = '#a077ef',
  keyword = '#d07e22',
  func = '#80b028',
  type = '#4ba6cb',
  variable = '#ececec',
  entity = '#ffcf22',
  punctuation = '#e1efff',
  param = '#d07e22',
  error = '#f44542',
  warning = '#e58520',

  -- Additional colors
  orange = '#ebb579',
  yellow = '#ffee80',
  green = '#80b028',
  soft_green = '#929c69',
  blue = '#4c80ba',
  dark_blue = '#1f528d',
  purple = '#a177ef',
  soft_red = '#af5b56',
}

function M.setup()
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'etterglod'
  vim.o.background = 'dark'
  vim.o.termguicolors = true

  local highlights = {
    -- Editor
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg_alt },
    CursorLine = { bg = colors.bg_highlight },
    CursorColumn = { bg = colors.bg_highlight },
    ColorColumn = { bg = colors.bg_highlight },
    Cursor = { fg = colors.bg, bg = colors.cursor },
    lCursor = { fg = colors.bg, bg = colors.cursor },
    CursorIM = { fg = colors.bg, bg = colors.cursor },

    -- Line numbers
    LineNr = { fg = colors.indent_guide },
    CursorLineNr = { fg = colors.line_nr, bold = true },

    -- Visual mode
    Visual = { bg = colors.bg_visual },
    VisualNOS = { bg = colors.bg_visual },

    -- Search
    Search = { bg = colors.warning, fg = colors.bg },
    IncSearch = { bg = colors.warning, fg = colors.bg },

    -- Splits and windows
    VertSplit = { fg = colors.border },
    WinSeparator = { fg = colors.border },

    -- Statusline
    StatusLine = { fg = colors.fg, bg = colors.bg_alt },
    StatusLineNC = { fg = colors.fg_dim, bg = colors.bg_alt },

    -- Tabline
    TabLine = { fg = colors.fg_dim, bg = colors.bg_alt },
    TabLineFill = { bg = colors.bg_alt },
    TabLineSel = { fg = colors.fg, bg = colors.bg },

    -- Popup menu
    Pmenu = { fg = colors.fg, bg = colors.bg_alt },
    PmenuSel = { fg = colors.fg, bg = colors.bg_highlight },
    PmenuSbar = { bg = colors.bg_alt },
    PmenuThumb = { bg = colors.fg_dim },

    -- Messages
    ErrorMsg = { fg = colors.error },
    WarningMsg = { fg = colors.warning },
    ModeMsg = { fg = colors.fg },
    MoreMsg = { fg = colors.green },

    -- Syntax highlighting
    Comment = { fg = colors.comment, italic = true },

    Constant = { fg = colors.constant },
    String = { fg = colors.string },
    Character = { fg = colors.purple },
    Number = { fg = colors.number },
    Boolean = { fg = colors.number },
    Float = { fg = colors.number },

    Identifier = { fg = colors.variable },
    Function = { fg = colors.func },

    Statement = { fg = colors.keyword },
    Conditional = { fg = colors.keyword },
    Repeat = { fg = colors.keyword },
    Label = { fg = colors.keyword },
    Operator = { fg = colors.punctuation },
    Keyword = { fg = colors.keyword },
    Exception = { fg = colors.keyword },

    PreProc = { fg = colors.entity },
    Include = { fg = colors.keyword },
    Define = { fg = colors.keyword },
    Macro = { fg = colors.entity },
    PreCondit = { fg = colors.keyword },

    Type = { fg = colors.type, italic = true },
    StorageClass = { fg = colors.orange },
    Structure = { fg = colors.type },
    Typedef = { fg = colors.type },

    Special = { fg = colors.entity },
    SpecialChar = { fg = colors.yellow },
    Tag = { fg = colors.blue },
    Delimiter = { fg = colors.punctuation },
    SpecialComment = { fg = colors.comment },
    Debug = { fg = colors.warning },

    -- Underlined
    Underlined = { underline = true },

    -- Ignore
    Ignore = { fg = colors.fg_dim },

    -- Error
    Error = { fg = colors.error },

    -- Todo
    Todo = { fg = colors.warning, bold = true },

    -- Treesitter
    ['@comment'] = { link = 'Comment' },
    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { fg = colors.number },
    ['@string'] = { link = 'String' },
    ['@number'] = { link = 'Number' },
    ['@boolean'] = { link = 'Boolean' },
    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { fg = colors.blue },
    ['@parameter'] = { fg = colors.param, italic = true },
    ['@keyword'] = { link = 'Keyword' },
    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { fg = colors.blue, italic = true },
    ['@type.definition'] = { fg = colors.entity, bold = true },
    ['@variable'] = { link = 'Identifier' },
    ['@variable.builtin'] = { fg = colors.blue },
    ['@punctuation'] = { fg = colors.punctuation },
    ['@punctuation.delimiter'] = { fg = colors.punctuation },
    ['@punctuation.bracket'] = { fg = colors.punctuation },
    ['@tag'] = { fg = colors.blue },
    ['@tag.attribute'] = { fg = colors.func },
    ['@operator'] = { link = 'Operator' },
    ['@field'] = { link = 'Identifier' },
    ['@property'] = { link = 'Identifier' },

    -- LSP
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warning },
    DiagnosticInfo = { fg = colors.blue },
    DiagnosticHint = { fg = colors.fg_dim },

    -- Git
    DiffAdd = { fg = colors.green },
    DiffChange = { fg = colors.warning },
    DiffDelete = { fg = colors.error },
    DiffText = { fg = colors.warning, bold = true },

    -- Indent guides (for indent-blankline plugin)
    IndentBlanklineChar = { fg = colors.indent_guide },
    IndentBlanklineContextChar = { fg = colors.indent_guide_active },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  vim.api.nvim_set_hl(0, "Directory", { fg = colors.blue, bold = true })
end

return M
