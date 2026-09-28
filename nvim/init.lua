vim.o.autoread = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.wo.number = true
vim.wo.relativenumber = true -- set relative line numbers
vim.wo.cursorline = true
vim.opt.cursorlineopt = 'number' -- highliht only the number
vim.opt.signcolumn = 'yes' -- Always show the sign column to prevent text shift
require('config.clipboard')
-- vim.o.wrap = false -- displays lines as one long line
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.undofile = true -- Save undo history
vim.o.mouse = 'a' -- enable mouse mode, for highlights
-- vim.o.mouse = '' -- disable mouse
vim.o.autoindent = true -- copy indent from current line when starting a new one
vim.o.ignorecase = true -- case-insensitive searching, unless \C or capital in search
vim.o.smartcase = true -- smart case
vim.opt.showmode = false -- disable showing mode
vim.opt.splitright = true -- split right by default
vim.opt.shortmess:append('I') -- hide the opening screen

-- Start typing immediately when launched without a file or directory.
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('startup_insert', { clear = true }),
  once = true,
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.buftype == '' and vim.bo.modifiable then
      vim.cmd.startinsert()
    end
  end,
})

-- Force Normal mode when entering a window or buffer
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('force_normal_mode', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'n' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    end
  end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  command = 'wincmd =',
})

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('help_vsplit', { clear = true }),
  pattern = 'help',
  command = 'wincmd L',
})

-- Setup lazy.nvim
require('lazy-bootstrap')
require('lazy').setup({
  spec = {
    -- import your plugins
    { import = 'plugins' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
  -- automatically check for plugin updates
  checker = { enabled = false },
  -- check for changes
  change_detection = { enabled = false },
  -- No plugin needs luarocks; skips the check (and its warning on servers without it).
  rocks = { enabled = false },
  performance = {
    rtp = {
      -- Built-in plugins we never use. netrw is replaced by oil and neo-tree.
      disabled_plugins = { 'gzip', 'netrwPlugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin' },
    },
  },
})

-- Keymaps
require('keymaps')
