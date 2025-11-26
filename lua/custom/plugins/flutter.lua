return {
  {
    'akinsho/flutter-tools.nvim',
    ft = { 'dart' },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'mfussenegger/nvim-dap',
        lazy = true,
      },
      {
        'rcarriga/nvim-dap-ui',
        lazy = true,
      },
      {
        'nvim-telescope/telescope.nvim',
        lazy = true,
      },
    },

    config = function()
      require('flutter-tools').setup {
        ui = {
          border = 'rounded',
          notification_style = 'native',
        },
        decorations = {
          statusline = { app_version = true, device = true, project_config = true },
        },
        widget_guides = { enabled = true },
        closing_tags = {
          highlight = 'Comment',
          prefix = '//',
          enabled = true,
          priority = 10,
        },
        dev_log = {
          enabled = true,
          notify_errors = true,
          focus_on_open = false,
        },
        lsp = {
          color = {
            enabled = false,
            virtual_text = true,
            virtual_text_str = '■',
          },
          on_attach = function(_, _) end,
          settings = {
            showTodos = true,
            updateImportsOnRename = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
        },
      }

      local map = vim.keymap.set
      map('n', '<C-s>', ':FlutterReload<CR>', { desc = 'Flutter Hot Reload', silent = true })
      map('n', '<leader>fR', ':FlutterRestart<CR>', { desc = 'Flutter Hot Restart' })
      map('n', '<F5>', ':FlutterRun<CR>', { desc = 'Flutter Run' })
      map('n', '<F8>', ':FlutterQuit<CR>', { desc = 'Flutter Quit' })
      map('n', '<leader>fL', ':FlutterLog<CR>', { desc = 'Show Flutter Logs' })
      map('n', '<leader>fl', ':FlutterDevices<CR>', { desc = 'Flutter Devices' })
      map('n', '<leader>fv', ':FlutterEmulators<CR>', { desc = 'Flutter Emulators' })
      map('n', '<leader>fD', ':FlutterDevTools<CR>', { desc = 'Flutter Dev Tools' })
      map('n', '<leader>fd', function()
        require('dapui').toggle()
      end, { desc = 'Toggle Debugger UI' })
      map('n', '<leader>ft', ':FlutterLogToggle<CR>', { desc = 'Flutter Log Toggle' })
      map('n', '<leader>fc', ':FlutterLogClear<CR>', { desc = 'Flutter Log Clear' })
    end,
  },
}
