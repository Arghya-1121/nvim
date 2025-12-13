return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      enable = true,
      max_lines = 3,
      trim_scope = 'outer',
      patterns = {
        default = {
          'class',
          'function',
          'method',
          'for',
          'while',
          'if',
          'switch',
          'case',
        },
      },
    },
  },

  -- {
  --   "simrat39/symbols-outline.nvim",
  --   cmd = "SymbolsOutline",
  --   keys = {
  --     { "<leader>co", "<cmd>SymbolsOutline<cr>", desc = "Code Outline" },
  --   },
  --   opts = {
  --     position = "right",
  --     width = 25,
  --     auto_close = true,
  --     auto_preview = true,
  --     show_numbers = true,
  --     show_relative_numbers = true,
  --   },
  -- },
}
