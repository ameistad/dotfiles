local local_path = vim.fn.expand('~/Projects/etterglod.nvim')
local use_local = vim.fn.isdirectory(local_path) == 1

local plugin

if use_local then
	plugin = {
		dir = local_path,
		name = 'etterglod',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd('colorscheme etterglod')
		end,
	}
else
	plugin = {
		'ameistad/etterglod.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd('colorscheme etterglod')
		end,
	}
end

return plugin
