local km = require('utils.keymap_helpers')
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', km.with_desc('Toggle File [E]xplorer'))

return {
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'MunifTanjim/nui.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			filesystem = {
				hijack_netrw_behavior = 'disabled',
			},
		},
	},
}
