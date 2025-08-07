return {
  "andweeb/presence.nvim",
  event = "VeryLazy", -- or "BufReadPre" to load earlier
  config = function()
    require("presence").setup({
      -- Customize as needed:
      auto_update = true,
      neovim_image_text = "Editing with Neovim",
      main_image = "neovim", -- "neovim" or "file"
      enable_line_number = true,
      buttons = true,
      show_time = true,
      -- more options at: https://github.com/andweeb/presence.nvim#setup
    })
  end,
}
