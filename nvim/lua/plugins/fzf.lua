return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { 'nvim-mini/mini.icons' },
  opts = {},
  keys = {
    { '<leader>f',  '<cmd>FzfLua files<cr>',   desc = 'Find files' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = 'Find files' },
  },
}
