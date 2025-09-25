return {
	'stevearc/oil.nvim',
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	lazy = false,
	keys = {
		{ '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
	},
}
