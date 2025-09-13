return {
	'olimorris/codecompanion.nvim',
	opts = {
		adapters = {
			http = {
				openai = function()
					return require('codecompanion.adapters').extend('openai', {
						schema = {
							model = {
								default = 'claude-sonnet-4',
							},
						},
					})
				end,
				--     anthropic = function()
				--       return require("codecompanion.adapters").extend("anthropic", {
				--         env = {
				--           api_key = "cmd:op read op://development/anthropic-api-key-codecompanion/api-key --no-newline",
				--         },
				--       })
				--     end,
			},
		},
		strategies = {
			chat = {
				adapter = 'copilot',
				model = 'claude-sonnet-4',
				slash_commands = {
					['file'] = {
						keymaps = {
							modes = {
								i = '<C-f>',
								n = { '<C-f>', 'gf' },
							},
						},
					},
					['buffer'] = {
						keymaps = {
							modes = {
								i = '<C-b>',
								n = { '<C-b>', 'gb' },
							},
						},
					},
				},
			},
			inline = {
				adapter = 'copilot',
			},
		},
	},
	dependencies = {
		{ 'nvim-lua/plenary.nvim' },
		{ 'nvim-treesitter/nvim-treesitter' },
		{
			'saghen/blink.cmp',
			lazy = false,
			version = '*',
			opts = {
				keymap = {
					preset = 'enter',
					['<S-Tab>'] = { 'select_prev', 'fallback' },
					['<Tab>'] = { 'select_next', 'fallback' },
				},
				cmdline = { sources = { 'cmdline' } },
				sources = {
					default = { 'lsp', 'path', 'buffer' },
				},
			},
		},
	},
	keys = {
		{
			'<C-a>',
			'<cmd>CodeCompanionActions<CR>',
			desc = 'Open the action palette',
			mode = { 'n', 'v' },
		},
		{
			'<Leader>a',
			'<cmd>CodeCompanionChat Toggle<CR>',
			desc = 'Toggle a chat buffer',
			mode = { 'n', 'v' },
		},
		{
			'<LocalLeader>a',
			'<cmd>CodeCompanionChat Add<CR>',
			desc = 'Add code to a chat buffer',
			mode = { 'v' },
		},
		--    { '<leader>cc', ':CodeCompanionChat<CR>',   desc = 'Open CodeCompanion Chat' },
		--    { '<leader>ca', ':CodeCompanionAction<CR>', desc = 'Open CodeCompanion Actions' },
	},
	display = {
		chat = {
			start_in_insert_mode = false,
		},
	},
}
