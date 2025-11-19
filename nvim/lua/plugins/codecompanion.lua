return {
	'olimorris/codecompanion.nvim',
	init = function()
		local group = vim.api.nvim_create_augroup('CodeCompanionStatusline', { clear = true })

		local function update_buffer_name(bufnr, adapter_name, model_name)
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			local metadata = _G.codecompanion_chat_metadata[bufnr]
			if not metadata or not metadata.adapter then
				return
			end

			local final_adapter_name = adapter_name or metadata.adapter.name or 'unknown'
			local final_model_name = model_name or metadata.adapter.model or 'unknown'

			local new_name = string.format('[%s: %s]', final_adapter_name, final_model_name)
			vim.api.nvim_buf_set_name(bufnr, new_name)
		end
		vim.api.nvim_create_autocmd({ 'User' }, {
			pattern = { 'CodeCompanionChatOpened' },
			group = group,
			callback = function(event)
				local bufnr = event.data and event.data.bufnr
				if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
					update_buffer_name(bufnr, nil, nil)
				end
			end,
		})

		vim.api.nvim_create_autocmd({ 'User' }, {
			pattern = { 'CodeCompanionChatModel' },
			group = group,
			callback = function(event)
				local bufnr = event.data and event.data.bufnr
				if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
					local model_name = event.data.model or event.data.adapter and event.data.adapter.model
					update_buffer_name(bufnr, nil, model_name)
				end
			end,
		})

		vim.api.nvim_create_autocmd({ 'User' }, {
			pattern = { 'CodeCompanionChatAdapter' },
			group = group,
			callback = function(event)
				local bufnr = event.data and event.data.bufnr
				if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
					local adapter_name = event.data.adapter and event.data.adapter.name
					local model_name = event.data.adapter and event.data.adapter.model
					update_buffer_name(bufnr, adapter_name, model_name)
				end
			end,
		})
	end,
	opts = {
		-- display = {
		-- 	chat = {
		-- 		start_in_insert_mode = true,
		-- 	},
		-- },
		adapters = {
			http = {
				copilot = function()
					return require('codecompanion.adapters').extend('copilot', {
						schema = {
							model = {
								default = 'claude-sonnet-4.5',
							},
						},
					})
				end,
				anthropic = function()
					return require('codecompanion.adapters').extend('anthropic', {
						env = {
							api_key = 'cmd:op read op://development/anthropic-api-key-codecompanion/api-key --no-newline',
						},
					})
				end,
			},
		},
		strategies = {
			chat = {
				adapter = 'copilot',
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
				roles = {
					llm = function(adapter)
						return 'AI (' .. adapter.formatted_name .. ')'
					end,

					user = 'Me',
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
		{ 'saghen/blink.cmp' },
	},
	keys = {
		{
			'<Leader>a',
			'<cmd>CodeCompanionChat Toggle<CR>',
			desc = 'Toggle [A]I Chat',
			mode = { 'n', 'v' },
		},
	},
}
