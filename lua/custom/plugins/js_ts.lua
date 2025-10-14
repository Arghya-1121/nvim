return {
  -- LSP Support for JS/TS
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsserver = {},
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'javascript',
        'typescript',
        'tsx',
        'json',
      })
    end,
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      },
    },
  },
}

