return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    files = {
      fd_opts = [[--color=never --type f --hidden --follow --exclude .git --ignore-file ]]
        .. vim.fn.stdpath("config")
        .. "/vim-ignore",
    },
    grep = {
      hidden = false,
      no_ignore = false,
    },
  },
  keys = {
    { "<leader>sf", "<cmd>FzfLua files<CR>", desc = "Search Files" },
    { "<leader>sb", "<cmd>FzfLua buffers<CR>", desc = "Find buffers" },
    { "<leader>sg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    { "<leader>sh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
    { "<leader>st", "<cmd>FzfLua tags<CR>", desc = "Find tags" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep current word" },
    { "<leader>sc", "<cmd>FzfLua files cwd~/.config<CR>", desc = "Search Files in ~/.config" },
  },
}
