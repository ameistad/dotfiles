return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  -- or if using mini.icons/mini.nvim
  -- dependencies = { 'nvim-mini/mini.icons' },
  opts = {},
  keys = {
    { '<leader>ff',  '<cmd>FzfLua files<cr>',   desc = 'Find files' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>',    desc = 'Find buffers' },
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>',  desc = 'Live grep' },
    { '<leader>fh', '<cmd>FzfLua help_tags<cr>',  desc = 'Help tags' },
    { '<leader>ft', '<cmd>FzfLua tags<cr>',       desc = 'Find tags' },
    { '<leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep current word' },
  },
}
