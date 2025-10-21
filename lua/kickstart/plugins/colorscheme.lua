return {
  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = 'transparent',
  --       floats = 'transparent',
  --       keywords = { italic = true },
  --       comments = { italic = true },
  --     },
  --   },
  --   config = function(_, opts)
  --     require('tokyonight').setup(opts)
  --     vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('onedark').setup {
  --       style = 'deep',
  --     }
  --     -- Enable theme
  --     require('onedark').load()
  --   end,
  -- },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup {
        variyant = 'dark',
        transparent = true,
      }
      require('cyberdream').load()
    end,
  },
  -- {
  --   'olimorris/onedarkpro.nvim',
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     require('onedarkpro').load()
  --   end,
  -- },
}
