return {

  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     style = 'night', -- or storm / moon / day
  --     transparent = false,
  --     --     styles = {
  --     --       sidebars = 'transparent',
  --     --       floats = 'transparent',
  --     --       keywords = { italic = true },
  --     --       comments = { italic = true },
  --     --     },
  --     on_colors = function(colors)
  --       -- Change main editor background
  --       colors.bg = '#0a0a0a'
  --       colors.bg_dark = '#0a0a0a'
  --       colors.bg_float = '#0a0a0a'
  --       colors.bg_sidebar = '#0a0a0a'
  --     end,
  --   },
  --   config = function(_, opts)
  --     require('tokyonight').setup(opts)
  --     vim.cmd 'colorscheme tokyonight'
  --   end,
  -- },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        compile = false,
        transparent = false,
        dimInactive = false,
        globalStatus = true,
        terminalColors = true,
        -- colors = {},

        overrides = function(colors)
          local theme = colors.theme
          return {
            Normal = { bg = '#0a0a0a' },
            NormalFloat = { bg = '#0a0a0a' },
            FloatBorder = { bg = '#0a0a0a' },
            SignColumn = { bg = '#0a0a0a' },
            LineNr = { bg = '#0a0a0a' },
            CursorLine = { bg = '#202020' },
            CursorLineNr = { bg = '#001a1a' },
            StatusLine = { bg = '#0a0a0a' },
            Comment = { fg = theme.syn.comment, italic = true },
            Keyword = { fg = theme.syn.keyword },
            Identifier = { fg = theme.syn.identifier },
            Function = { fg = theme.syn.fun },
            Statement = { fg = theme.syn.statement },
            Operator = { fg = theme.syn.operator },
            Constant = { fg = theme.syn.constant, italic = true },
            String = { fg = theme.syn.string, italic = true },
          }
        end,
      }
      vim.cmd 'colorscheme kanagawa'
    end,
  },

  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   lazy = false,
  --   priority = 1000,
  --
  --   opts = {
  --     flavour = 'mocha', -- darkest catppuccin
  --     transparent_background = false,
  --     term_colors = true,
  --
  --     styles = {
  --       comments = { 'italic' },
  --       conditionals = { 'italic' },
  --     },
  --
  --     integrations = {
  --       treesitter = true,
  --       native_lsp = {
  --         enabled = true,
  --         inlay_hints = { background = false },
  --       },
  --       cmp = true,
  --       telescope = true,
  --       which_key = true,
  --       dap = true,
  --       dap_ui = true,
  --       gitsigns = true,
  --       indent_blankline = {
  --         enabled = true,
  --         scope_color = 'lavender',
  --       },
  --     },
  --   },
  --
  --   config = function(_, opts)
  --     require('catppuccin').setup(opts)
  --     vim.cmd 'colorscheme catppuccin-mocha'
  --   end,
  -- },
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
  --       style = 'warmer',
  --     }
  --     -- Enable theme
  --     require('onedark').load()
  --   end,
  -- },

  -- {
  --   'scottmckendry/cyberdream.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('cyberdream').setup {
  --       variyant = 'dark',
  --       -- transparent = true,
  --     }
  --     require('cyberdream').load()
  --   end,
  -- },

  -- {
  --   'olimorris/onedarkpro.nvim',
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     require('onedarkpro').load()
  --   end,
  -- },

  -- {
  --   'AlexvZyl/nordic.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('nordic').setup {
  --       italic_comments = true,
  --     }
  --     require('nordic').load()
  --   end,
  -- },

  -- {
  --   'vague-theme/vague.nvim',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other plugins
  --   config = function()
  --     require('vague').setup {
  --       colors = {
  --         bg = '#141415',
  --         inactiveBg = '#1c1c24',
  --         fg = '#cdcdcd',
  --         floatBorder = '#878787',
  --         line = '#252530',
  --         comment = '#606079',
  --         builtin = '#b4d4cf',
  --         func = '#c48282',
  --         string = '#e8b589',
  --         number = '#e0a363',
  --         property = '#c3c3d5',
  --         constant = '#aeaed1',
  --         parameter = '#bb9dbd',
  --         visual = '#333738',
  --         error = '#d8647e',
  --         warning = '#f3be7c',
  --         hint = '#7e98e8',
  --         operator = '#90a0b5',
  --         keyword = '#6e94b2',
  --         type = '#9bb4bc',
  --         search = '#405065',
  --         plus = '#7fa563',
  --         delta = '#f3be7c',
  --       },
  --     }
  --     vim.cmd 'colorscheme vague'
  --   end,
  -- },

  -- {
  --   'rmehri01/onenord.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('onenord').load()
  --   end,
  -- },

  -- {
  --   'nyoom-engineering/oxocarbon.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.opt.background = 'dark'
  --     vim.cmd 'colorscheme oxocarbon'
  --   end,
  -- },
}
