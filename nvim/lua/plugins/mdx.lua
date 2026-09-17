return {
  'davidmh/mdx.nvim',
  enabled = require('config.profile').is_dev(),
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
