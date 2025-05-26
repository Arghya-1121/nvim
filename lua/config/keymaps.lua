-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

vim.keymap.set("n", "<C-\\>", function()
  Util.terminal(nil, { cwd = Util.root(), float = true })
end, { desc = "Toggle Floating Terminal" })
vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle Floating Terminal" })
