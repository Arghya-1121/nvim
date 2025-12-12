return {
  {
    'Civitasv/cmake-tools.nvim',
    ft = { 'cmake' },
    cmd = { 'CMakeGenerate', 'CMakeBuild', 'CMakeClean' },
    opts = {},
  },
  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    event = 'LspAttach',
    config = function()
      vim.schedule(function()
        require('clangd_extensions').setup()
      end)
    end,
  },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
      formatters_by_ft = {
        cpp = { 'clang_format' },
        c = { 'clang_format' },
      },
      format_on_save = {
        timeout_ms = 100,
        lsp_format = 'fallback',
      },
    },
  },
}
