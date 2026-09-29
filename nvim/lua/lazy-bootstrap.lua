-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
  -- `Lazy! restore` never moves lazy.nvim itself, so pin the fresh clone to the lockfile here.
  -- Otherwise the next lockfile write records whatever `stable` was and dirties the repo.
  local ok, lock = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath('config') .. '/lazy-lock.json'), '\n'))
  end)
  local commit = ok and lock['lazy.nvim'] and lock['lazy.nvim'].commit
  if commit then
    vim.fn.system({ 'git', '-C', lazypath, 'checkout', '--quiet', commit })
  end
end
vim.opt.rtp:prepend(lazypath)
