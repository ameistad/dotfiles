-- Use a local checkout of the colorscheme when there is one (for developing it), else GitHub.
local projects = vim.env.PROJECTS_DIRECTORY or vim.fn.expand('~/Projects')
local local_path = vim.fs.joinpath(vim.fn.expand(projects), 'etterglod.nvim')

local plugin = {
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd('colorscheme etterglod')
  end,
}

if vim.fn.isdirectory(local_path) == 1 then
  plugin.dir = local_path
  plugin.name = 'etterglod'
else
  plugin[1] = 'ameistad/etterglod.nvim'
end

return plugin
