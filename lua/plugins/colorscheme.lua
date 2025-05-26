return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     window = {
  --       mappings = {
  --         ["<esc>"] = "close_window",
  --       },
  --     },
  --     default_component_configs = {
  --       container = {
  --         enable_character_fade = false,
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("neo-tree").setup(opts)
  --
  --     vim.cmd([[
  --       hi NeoTreeNormal guibg=NONE ctermbg=NONE
  --       hi NeoTreeNormalNC guibg=NONE ctermbg=NONE
  --       hi NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE
  --       hi NeoTreeWinSeparator guibg=NONE ctermbg=NONE
  --     ]])
  --   end,
  -- },
}
