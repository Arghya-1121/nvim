return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {
          cmd = { 'clangd', '--background-index', '--clang-tidy' },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        },
      },
    },
  },

  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/bin/OpenDebugAD7',
      }
      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
    dependencies = {
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
  },
}

