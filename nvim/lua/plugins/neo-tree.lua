local km = require('utils.keymap_helpers')
vim.keymap.set('n', '<leader>e', function()
	local is_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == 'neo-tree' then
			is_open = true
			break
		end
	end

	if is_open then
		vim.cmd('Neotree close')
		return
	end

	local bufname = vim.api.nvim_buf_get_name(0)
	local is_real_file = vim.bo.buftype == '' and bufname ~= '' and vim.fn.filereadable(bufname) == 1

	if is_real_file then
		vim.cmd('Neotree reveal')
	else
		vim.cmd('Neotree toggle')
	end
end, km.with_desc('Toggle File [E]xplorer'))

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
