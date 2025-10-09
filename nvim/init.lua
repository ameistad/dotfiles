vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.wo.number = true
vim.wo.relativenumber = true -- set relative line numbers
vim.wo.cursorline = true
vim.opt.cursorlineopt = 'number' -- highliht only the number
vim.schedule(function() -- Sync clipboard between OS and Neovim.
	vim.o.clipboard = 'unnamedplus'
	vim.g.clipboard = 'osc52'
end)
vim.o.wrap = false -- displays lines as one long line
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.undofile = true -- Save undo history
vim.o.mouse = 'a' -- enable mouse mode, for highlights
-- vim.o.mouse = '' -- disable mouse
vim.o.autoindent = true -- copy indent from current line when starting a new one
vim.o.ignorecase = true -- case-insensitive searching, unless \C or capital in search
vim.o.smartcase = true -- smart case
vim.opt.showmode = false -- disable showing mode
vim.opt.splitright = true -- split right by default

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
})

-- Keymaps
require('keymaps')
