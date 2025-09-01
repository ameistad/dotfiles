return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
