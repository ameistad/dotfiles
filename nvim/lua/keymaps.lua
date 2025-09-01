vim.keymap.set('n', '<leader>sv', function()
  vim.cmd('source $MYVIMRC')
  vim.notify('✅ Neovim config reloaded!', vim.log.levels.INFO)
end, { desc = 'Reload config' })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
