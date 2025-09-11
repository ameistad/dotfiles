local M = {}
M.default_opts = { noremap = true, silent = true }
function M.with_desc(opts, desc)
  if type(opts) == "string" and desc == nil then
    desc = opts
    opts = nil
  end
  return vim.tbl_extend("force", M.default_opts, opts or {}, { desc = desc })
end

return M
