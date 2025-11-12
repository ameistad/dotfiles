return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	-- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	---@diagnostic disable-next-line: missing-fields
	config = function()
		require('nvim-treesitter.configs').setup({
			auto_install = true,
			sync_install = false,
			ignore_install = {},
			ensure_installed = {
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
			},
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { 'astro' },
			},
			indent = { enable = true },
		})
	end,
}
