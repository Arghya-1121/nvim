return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-jdtls',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'DAP Continue',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'DAP Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'DAP Step Into',
    },
    {
      '<F12>',
      function()
        require('dap').step_out()
      end,
      desc = 'DAP Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'DAP Breakpoint',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'DAP UI',
    },
  },
  config = function(_, _)
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      ensure_installed = { 'codelldb', 'java-debug-adapter' },
      automatic_installation = true,
      handlers = {},
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Java Launch',
        mainClass = function()
          return vim.fn.input 'Main class: '
        end,
        projectName = function()
          return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        end,
      },
    }
    dap.configurations.rust = {
      {
        name = 'Rust Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.getcwd() .. '/target/debug/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations['c++'] = dap.configurations.cpp
    assert(dap.configurations.rust, 'Rust DAP config missing')
    assert(dap.configurations.cpp, 'cpp DAP config missing')
    dapui.setup()
    dap.listeners.after.event_initialized['dapui'] = dapui.open
    dap.listeners.before.event_terminated['dapui'] = dapui.close
    dap.listeners.before.event_exited['dapui'] = dapui.close
  end,
}
