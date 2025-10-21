return {
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('flutter-tools').setup {
        ui = {
          border = 'rounded',
          notification_style = 'native',
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
            project_config = true,
          },
        },
        dev_log = {
          enabled = true,
          notify_errors = false,
          open_cmd = 'tabedit',
        },
        widget_guides = { enabled = true },
        closing_tags = {
          highlight = 'Comment',
          prefix = '// ',
          enabled = true,
        },
        lsp = {
            color = {
            enabled = true,
            background = false,
            virtual_text = true,
          },
          on_attach = function(_, _)
            -- You can add keymaps here later
          end,
          settings = {
            showTodos = true,
            updateImportsOnRename = true,
            analysisExcludedFolders = {
              '${workspaceRoot}/.dart_tool/',
              '${workspaceRoot}/.idea/',
              '${workspaceRoot}/.vscode/',
              '${workspaceRoot}/build/',
              '${workspaceRoot}/android/',
              '${workspaceRoot}/ios/',
              '${workspaceRoot}/windows/',
              '${workspaceRoot}/linux/',
              '${workspaceRoot}/macos/',
            },
          },
          color = {
            enabled = false,
            virtual_text = true,
            virtual_text_str = '■',
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = true,
          filter = nil,
          -- open_cmd = "7split",
          focus_on_open = false,
        },
        closing_tags = {
          highlight = 'Comment',
          enabled = true,
          prefix = '->',
          priority = 10,
        },
        widget_guides = {
          enabled = true,
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
            project_config = true,
          },
        },
        ui = {
          border = 'rounded',
          notify_errors = true,
        },
      }
      if vim.fn.expand '%:t' == 'pubspec.yaml' then
        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          callback = function()
            vim.cmd 'FlutterPubGet'
          end,
        })
      end

      --      vim.keymap.set("n", "<leader>fr", ":FlutterHotReload<CR>", { desc = "Flutter Hot Reload" })
      vim.keymap.set('n', '<C-s>', ':FlutterReload<CR>', { desc = 'Flutter Hot Reload', silent = true })
      vim.keymap.set('n', '<leader>fR', ':FlutterRestart<CR>', { desc = 'Flutter Hot Restart' })
      vim.keymap.set('n', '<F5>', ':FlutterRun<CR>', { desc = 'Flutter Run' })
      vim.keymap.set('n', '<F8>', 'FlutterQuit<CR>', { desc = 'Flutter Quit' })
      vim.keymap.set('n', '<leader>fL', ':FlutterLog<CR>', { desc = 'Show Flutter Logs' })
      vim.keymap.set('n', '<leader>fl', ':FlutterDevices<CR>', { desc = 'Flutter Devices' })
      vim.keymap.set('n', '<leader>fv', ':FlutterEmulators<CR>', { desc = 'Flutter Emulators' })
      vim.keymap.set('n', '<leader>fD', ':FlutterDevTools<CR>', { desc = 'Flutter Dev Tools' })
      vim.keymap.set('n', '<leader>fd', function()
        require('dapui').toggle()
      end, { desc = 'Toggle Debugger UI' })
      vim.keymap.set('n', '<leader>ft', ':FlutterLogToggle<CR>', { desc = 'Flutter Log Toggle' })
      vim.keymap.set('n', '<leader>fc', ':FlutterLogClear<CR>', { desc = 'Flutter Log Clear' })
    end,
  },
}
