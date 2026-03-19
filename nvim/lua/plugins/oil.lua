return {
	'stevearc/oil.nvim',
	opts = {
		view_options = {
			show_hidden = false,
		},
		experimental_watch_for_changes = true,
	},
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	lazy = false,
	keys = {
		{ '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
	},
}
