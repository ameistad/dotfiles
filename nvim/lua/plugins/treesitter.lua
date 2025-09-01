return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter.configs").setup {
      auto_install = true,
      ensure_installed = { "go", "lua", "vim", "bash" },

      -- Enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- (Optional) Enable indentation
      indent = { enable = true },
    }
  end,
}
