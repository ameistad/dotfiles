return {
  "olimorris/codecompanion.nvim",
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
    adapters = {
      http = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:op read op://development/anthropic-api-key-codecompanion/api-key --no-newline",
            },
          })
        end,
      }

    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { '<leader>cc', ':CodeCompanionChat<CR>',   desc = 'Open CodeCompanion Chat' },
    { '<leader>ca', ':CodeCompanionAction<CR>', desc = 'Open CodeCompanion Actions' },
  },
}
