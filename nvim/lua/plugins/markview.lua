return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('markdown_wrap', { clear = true }),
      pattern = { 'markdown', 'quarto', 'rmd' },
      callback = function()
        -- Prefer comfortable prose editing. Markview cannot render tables while
        -- `wrap` is on, so use <leader>mw to toggle it off when a table matters.
        vim.opt_local.wrap = true
      end,
      desc = 'Wrap prose in Markdown-like buffers',
    })
  end,
  keys = {
    { '<leader>mv', '<cmd>Markview toggle<CR>', desc = 'Toggle Markview' },
    { '<leader>ms', '<cmd>Markview splitToggle<CR>', desc = 'Toggle Markview split preview' },
    {
      '<leader>mw',
      function()
        vim.wo.wrap = not vim.wo.wrap
        -- markview's OptionSet handler ignores wrap changes (it checks buffer 0),
        -- so redraw explicitly; tables only render when wrap is off.
        vim.cmd('Markview render')
        print(vim.wo.wrap and 'Wrap enabled' or 'Wrap disabled')
      end,
      desc = 'Toggle wrap (off to render Markview tables)',
    },
  },

  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
}
