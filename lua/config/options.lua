-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.relativenumber = true
-- Set default indent to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Override for Dart/Flutter files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- This clears background to match terminal
    vim.cmd([[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalNC guibg=NONE ctermbg=NONE
      hi VertSplit guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
      hi StatusLine guibg=NONE ctermbg=NONE
    ]])
  end,
})
-- -- Set colorscheme and background
-- vim.cmd.colorscheme("catppuccin") -- change as desired
-- vim.o.background = "dark"
--
-- -- Optional: manually override background if needed
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[
--       highlight Normal guibg=#000000
--       highlight NormalNC guibg=#000000
--       highlight SignColumn guibg=#000000
--       highlight VertSplit guibg=#000000
--     ]])
--   end,
-- })
