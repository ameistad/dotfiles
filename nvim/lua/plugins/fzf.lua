return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  opts = function()
    local actions = require('fzf-lua').actions
    return {
      files = {
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git --ignore-file ]] .. vim.fn.stdpath(
          'config'
        ) .. '/vim-ignore',
      },
      grep = {
        hidden = false,
        no_ignore = false,
      },
      actions = {
        files = {
          true,
          ['ctrl-h'] = actions.toggle_hidden,
          ['ctrl-i'] = actions.toggle_ignore,
          ['alt-h'] = false,
        },
      },
    }
  end,
  init = function()
    -- Route vim.ui.select through fzf-lua, loading it on first use instead of at startup.
    local builtin_select = vim.ui.select
    local lazy_select
    lazy_select = function(...)
      require('fzf-lua').register_ui_select()
      if vim.ui.select == lazy_select then -- registration failed; don't recurse
        vim.ui.select = builtin_select
      end
      return vim.ui.select(...)
    end
    vim.ui.select = lazy_select
  end,
  keys = {
    { '<leader>sf', '<cmd>FzfLua files<CR>', desc = 'Search Files' },
    { '<leader>sb', '<cmd>FzfLua buffers<CR>', desc = 'Find buffers' },
    { '<leader>sg', '<cmd>FzfLua live_grep<CR>', desc = 'Live grep' },
    { '<leader>sh', '<cmd>FzfLua help_tags<CR>', desc = 'Help tags' },
    { '<leader>st', '<cmd>FzfLua tags<CR>', desc = 'Find tags' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<CR>', desc = 'Grep current word' },
    { '<leader>sc', '<cmd>FzfLua files cwd~/.config<CR>', desc = 'Search Files in ~/.config' },
  },
}
