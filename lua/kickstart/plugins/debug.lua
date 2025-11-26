return {
  {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
      'mxsdev/nvim-dap-vscode-js',
    },

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      ---------------------------------------------------------------------------
      -- Mason DAP
      ---------------------------------------------------------------------------
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = {
          'debugpy',
          'node2',
          'chrome',
          'codelldb',
          'java-debug-adapter',
          'js-debug-adapter',
        },
      }

      ---------------------------------------------------------------------------
      -- UI SETUP
      ---------------------------------------------------------------------------
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      }

      ---------------------------------------------------------------------------
      -- AUTO OPEN/CLOSE UI
      ---------------------------------------------------------------------------
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      ---------------------------------------------------------------------------
      -- PYTHON
      ---------------------------------------------------------------------------
      require('dap-python').setup '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'

      ---------------------------------------------------------------------------
      -- JAVASCRIPT / TYPESCRIPT (VSCode JS Debug)
      ---------------------------------------------------------------------------
      require('dap-vscode-js').setup {
        adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal' },
      }

      for _, language in ipairs { 'typescript', 'javascript' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Node',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Chrome Debug',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
          },
        }
      end

      ---------------------------------------------------------------------------
      -- C / C++ / RUST (codelldb)
      ---------------------------------------------------------------------------
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
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      ---------------------------------------------------------------------------
      -- JAVA (requires nvim-jdtls)
      ---------------------------------------------------------------------------
      dap.configurations.java = {
        {
          type = 'java',
          request = 'launch',
          name = 'Launch Java',
          mainClass = '${file}',
        },
      }
    end,
  },

  -- DAP UI KEYMAPS (unchanged as you requested)
  {
    'rcarriga/nvim-dap-ui',
    config = function()
      vim.keymap.set('n', '<leader>du', function()
        require('dapui').toggle()
      end)
      vim.keymap.set('n', '<F11>', function()
        require('dap').continue()
      end)
      vim.keymap.set('n', '<F9>', function()
        require('dap').step_over()
      end)
      vim.keymap.set('n', '<F10>', function()
        require('dap').step_into()
      end)
      vim.keymap.set('n', '<F12>', function()
        require('dap').step_out()
      end)
      vim.keymap.set('n', '<leader>b', function()
        require('dap').toggle_breakpoint()
      end)
    end,
  },
}
