vim.g.mapleader = " " -- Set <space> as the leader key.
vim.g.maplocalleader = " "
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
vim.wo.number = true -- make line numbers default
vim.wo.relativenumber = true -- set relative line numbers

vim.schedule(function() -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = "unnamedplus"
end)
vim.o.wrap = false -- displays lines as one long line
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.undofile = true -- Save undo history
vim.o.mouse = "a" -- enable mouse mode, for highlights
vim.o.autoindent = true -- copy indent from current line when starting a new one
vim.o.ignorecase = true -- case-insensitive searching, unless \C or capital in search
vim.o.smartcase = true -- smart case
vim.opt.showmode = false -- disable showing mode
vim.opt.splitright = true -- split right by default

-- Colorscheme
require("etterglod").setup()

-- Keymaps
require("keymaps")

-- Setup lazy.nvim
require("lazy-bootstrap")
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
