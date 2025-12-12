return {
  {
    'Civitasv/cmake-tools.nvim',
    opts = {},
  },
  {
    'p00f/clangd_extensions.nvim',
    config = function()
      require('clangd_extensions').setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        cpp = { 'clang_format' },
        c = { 'clang_format' },
      },
    },
  },
}
