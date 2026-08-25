return {
	'OXY2DEV/markview.nvim',
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd('FileType', {
			group = vim.api.nvim_create_augroup('markview_nowrap', { clear = true }),
			pattern = { 'markdown', 'quarto', 'rmd' },
			callback = function()
				-- Markview intentionally renders tables only partially when lines wrap.
				vim.opt_local.wrap = false
			end,
			desc = 'Disable wrapping so Markview can render complete tables',
		})
	end,
	keys = {
		{ '<leader>mv', '<cmd>Markview toggle<CR>', desc = 'Toggle Markview' },
	},

	-- Completion for `blink.cmp`
	-- dependencies = { "saghen/blink.cmp" },
}
