return {
	'OXY2DEV/markview.nvim',
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd('FileType', {
			group = vim.api.nvim_create_augroup('markdown_wrap', { clear = true }),
			pattern = { 'markdown', 'quarto', 'rmd' },
			callback = function()
				-- Prefer comfortable prose editing. Markview keeps most rendering when
				-- wrapping; tables use a reduced preview to avoid layout glitches.
				vim.opt_local.wrap = true
			end,
			desc = 'Wrap prose in Markdown-like buffers',
		})
	end,
	keys = {
		{ '<leader>mv', '<cmd>Markview toggle<CR>', desc = 'Toggle Markview' },
		{ '<leader>ms', '<cmd>Markview splitToggle<CR>', desc = 'Toggle Markview split preview' },
	},

	-- Completion for `blink.cmp`
	-- dependencies = { "saghen/blink.cmp" },
}
