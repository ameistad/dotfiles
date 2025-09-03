return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  -- or if using mini.icons/mini.nvim
  -- dependencies = { 'nvim-mini/mini.icons' },
  opts = {},
  keys = {
    { '<leader>sf', '<cmd>FzfLua files<cr>',      desc = 'Find files' },
    { '<leader>sb', '<cmd>FzfLua buffers<cr>',    desc = 'Find buffers' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>',  desc = 'Live grep' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>',  desc = 'Help tags' },
    { '<leader>st', '<cmd>FzfLua tags<cr>',       desc = 'Find tags' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep current word' },
  },
}
