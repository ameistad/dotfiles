local km = require("utils.keymap_helpers")

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', km.default_opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", km.default_opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", km.default_opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", km.default_opts)
vim.keymap.set("n", "N", "Nzzzv", km.default_opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", km.default_opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", km.default_opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", km.default_opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", km.default_opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", km.default_opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", km.default_opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", km.default_opts)   -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", km.default_opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", km.with_desc("Split Window [V]ertically")) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", km.default_opts)                           -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", km.default_opts)                          -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", km.default_opts)                      -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", km.default_opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", km.default_opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", km.default_opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", km.default_opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", km.default_opts)   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", km.default_opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", km.default_opts)     --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", km.default_opts)     --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", km.default_opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", km.default_opts)
vim.keymap.set("v", ">", ">gv", km.default_opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', km.default_opts)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>dw", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "[D]iagnostics [W]orkspace" })
vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Codecompanion
-- vim.keymap.set('n', '<leader>cc', ':CodeCompanionChat<CR>', { desc = 'Open CodeCompanion Chat' })
