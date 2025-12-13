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
}
