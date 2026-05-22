local M = {}

M.current = vim.env.NVIM_PROFILE == 'dev' and 'dev' or 'lite'

function M.is_dev()
	return M.current == 'dev'
end

return M
