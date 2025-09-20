local km = require('utils.keymap_helpers')

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', km.default_opts)

-- Vertical scroll and center
-- use cinnamon for smooth scroll
local cinnamon = require('cinnamon')
cinnamon.setup()
vim.keymap.set('n', '<C-d>', function()
	cinnamon.scroll('<C-d>zz')
end, km.default_opts)
vim.keymap.set('n', '<C-u>', function()
	cinnamon.scroll('<C-u>zz')
end, km.default_opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', km.default_opts)
vim.keymap.set('n', 'N', 'Nzzzv', km.default_opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', km.default_opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', km.default_opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', km.default_opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', km.default_opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', km.default_opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', km.default_opts)
vim.keymap.set('n', '<leader>bc', ':bdelete!<CR>', km.with_desc('[C]lose Buffer'))
vim.keymap.set('n', '<leader>bn', '<cmd> enew <CR>', km.with_desc('[N]ew Buffer'))
vim.keymap.set('n', '<leader>ba', function()
	local bufs = vim.api.nvim_list_bufs()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, i in ipairs(bufs) do
		if i ~= current_buf then
			-- Check if buffer is valid and loaded before attempting to delete
			if vim.api.nvim_buf_is_valid(i) and vim.api.nvim_buf_is_loaded(i) then
				-- Use force delete and ignore errors for special buffers
				pcall(vim.api.nvim_buf_delete, i, { force = true })
			end
		end
	end
end, km.with_desc('Close [A]ll Other Buffers'))

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', km.with_desc('Split Window [V]ertically')) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', km.default_opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', km.default_opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', km.default_opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', km.default_opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', km.default_opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', km.default_opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', km.default_opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', km.default_opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', km.default_opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', km.default_opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', km.default_opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', km.default_opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', km.default_opts)
vim.keymap.set('v', '>', '>gv', km.default_opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', km.default_opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>dw', '<cmd>FzfLua diagnostics_workspace<CR>', { desc = '[D]iagnostics [W]orkspace' })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Add empty lines before and after cursor line
vim.keymap.set('n', 'mo', '<Cmd>call append(line(\'.\') - 1, repeat([\'\'], v:count1))<CR>', km.default_opts)
vim.keymap.set('n', 'mb', '<Cmd>call append(line(\'.\'),     repeat([\'\'], v:count1))<CR>', km.default_opts)
