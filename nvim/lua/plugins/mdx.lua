return {
  'davidmh/mdx.nvim',
  cond = require('config.profile').is_dev(),
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
