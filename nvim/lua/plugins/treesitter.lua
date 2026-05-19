local languages = {
	'astro',
	'bash',
	'css',
	'diff',
	'go',
	'html',
	'javascript',
	'lua',
	'luadoc',
	'markdown',
	'markdown_inline',
	'query',
	'tsx',
	'typescript',
	'vim',
	'vimdoc',
}

local filetypes = {
	'astro',
	'bash',
	'css',
	'diff',
	'go',
	'help',
	'html',
	'javascript',
	'javascriptreact',
	'lua',
	'markdown',
	'mdx',
	'query',
	'sh',
	'typescript',
	'typescriptreact',
	'vim',
}

local indent_filetypes = {
	'astro',
	'bash',
	'css',
	'go',
	'html',
	'javascript',
	'javascriptreact',
	'lua',
	'markdown',
	'mdx',
	'query',
	'sh',
	'typescript',
	'typescriptreact',
}

return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	lazy = false,
	build = function()
		local treesitter = require('nvim-treesitter')

		treesitter.install(languages):wait(300000)
		treesitter.update(languages):wait(300000)
	end,
	config = function()
		local ok, treesitter = pcall(require, 'nvim-treesitter')
		if ok and type(treesitter.install) == 'function' then
			treesitter.setup()

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
				pattern = filetypes,
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
					if args.match == 'astro' then
						vim.bo[args.buf].syntax = 'ON'
					end
				end,
			})

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('treesitter_indent', { clear = true }),
				pattern = indent_filetypes,
				callback = function(args)
					vim.bo[args.buf].indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()'
				end,
			})

			return
		end

		require('nvim-treesitter.configs').setup({
			auto_install = false,
			sync_install = false,
			ignore_install = {},
			ensure_installed = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { 'astro' },
			},
			indent = { enable = true },
		})
	end,
}
