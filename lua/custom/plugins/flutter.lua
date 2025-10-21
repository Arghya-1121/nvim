return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
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
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            enableSdkFormatter = false,
            renameFilesWithClasses = 'prompt',
            lineLength = 100,
            enableCompletionCommitCharacters = false, -- Prevents range errors
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
          on_attach = function(client, bufnr)
            -- Disable problematic LSP features
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true)
            end

            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end

            -- Flutter specific keymaps
            map('n', '<leader>fa', vim.lsp.buf.code_action, 'Code Action')
            map('v', '<leader>fa', vim.lsp.buf.code_action, 'Code Action')
            map('n', '<leader>fr', vim.lsp.buf.rename, 'Rename')
            map('n', '<leader>ff', vim.lsp.buf.format, 'Format')

            -- Hot reload/restart
            map('n', '<C-s>', ':FlutterReload<CR>', 'Hot Reload')
            map('n', '<leader>fR', ':FlutterRestart<CR>', 'Hot Restart')

            -- Widget helpers
            map('n', '<leader>fw', ':FlutterOutlineToggle<CR>', 'Widget Outline')
            map('n', '<leader>fW', ':FlutterOutlineOpen<CR>', 'Open Outline')
          end,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          register_configurations = function(paths)
            local dap = require 'dap'
            dap.adapters.dart = {
              type = 'executable',
              command = 'dart',
              args = { 'debug_adapter' },
            }
            dap.configurations.dart = {
              {
                type = 'dart',
                request = 'launch',
                name = 'Launch Flutter',
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = '${workspaceFolder}/lib/main.dart',
                cwd = '${workspaceFolder}',
              },
              {
                type = 'dart',
                request = 'launch',
                name = 'Launch Flutter (Profile)',
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = '${workspaceFolder}/lib/main.dart',
                cwd = '${workspaceFolder}',
                toolArgs = { '--profile' },
              },
              {
                type = 'dart',
                request = 'launch',
                name = 'Launch Flutter Tests',
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = '${workspaceFolder}/test',
                cwd = '${workspaceFolder}',
              },
            }
          end,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
      }

      -- Auto pub get on pubspec.yaml save
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = 'pubspec.yaml',
        callback = function()
          vim.cmd 'FlutterPubGet'
        end,
      })

      -- Helper function to check if we're in a Flutter project
      local function is_flutter_project()
        local pubspec = vim.fn.findfile('pubspec.yaml', '.;')
        if pubspec == '' then
          return false
        end

        -- Check if pubspec.yaml contains flutter dependency
        local content = vim.fn.readfile(pubspec)
        for _, line in ipairs(content) do
          if line:match 'flutter:' then
            return true
          end
        end
        return false
      end

      -- Set up autocmd to create Flutter-specific keymaps only in Flutter projects
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
        pattern = { '*.dart', 'pubspec.yaml', 'pubspec.lock' },
        callback = function()
          if not is_flutter_project() then
            return
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = 'Flutter: ' .. desc })
          end

          -- Run/Stop commands
          map('n', '<F5>', ':FlutterRun<CR>', 'Run')
          map('n', '<F6>', ':FlutterRun --flavor development -t lib/main_dev.dart<CR>', 'Run Dev')
          map('n', '<F7>', ':FlutterRun --flavor production -t lib/main_prod.dart<CR>', 'Run Prod')
          map('n', '<F8>', ':FlutterQuit<CR>', 'Quit')

          -- Device management
          map('n', '<leader>fd', ':FlutterDevices<CR>', 'Devices')
          map('n', '<leader>fe', ':FlutterEmulators<CR>', 'Emulators')

          -- Development tools
          map('n', '<leader>fD', ':FlutterDevTools<CR>', 'DevTools')
          map('n', '<leader>fo', ':FlutterOutlineToggle<CR>', 'Toggle Outline')

          -- Logs
          map('n', '<leader>fl', ':FlutterLogToggle<CR>', 'Toggle Logs')
          map('n', '<leader>fL', ':FlutterLogClear<CR>', 'Clear Logs')

          -- Pub commands
          map('n', '<leader>fp', ':FlutterPubGet<CR>', 'Pub Get')
          map('n', '<leader>fP', ':FlutterPubUpgrade<CR>', 'Pub Upgrade')
          map('n', '<leader>fu', ':!flutter pub outdated<CR>', 'Pub Outdated')

          -- Build commands
          map('n', '<leader>fb', ':!flutter build apk<CR>', 'Build APK')
          map('n', '<leader>fB', ':!flutter build appbundle<CR>', 'Build AAB')
          map('n', '<leader>fi', ':!flutter build ios<CR>', 'Build iOS')
          map('n', '<leader>fI', ':!flutter build ipa<CR>', 'Build IPA')
          map('n', '<leader>fw', ':!flutter build web<CR>', 'Build Web')

          -- Testing
          map('n', '<leader>ft', ':!flutter test<CR>', 'Run Tests')
          map('n', '<leader>fT', ':!flutter test --coverage<CR>', 'Test with Coverage')

          -- Clean/Analyze
          map('n', '<leader>fc', ':!flutter clean<CR>', 'Clean')
          map('n', '<leader>fA', ':!flutter analyze<CR>', 'Analyze')
          map('n', '<leader>fF', ':!dart format .<CR>', 'Format')

          -- Code generation
          map('n', '<leader>fg', ':!flutter pub run build_runner build --delete-conflicting-outputs<CR>', 'Build Runner')
          map('n', '<leader>fG', ':!flutter pub run build_runner watch --delete-conflicting-outputs<CR>', 'Build Runner Watch')

          -- Flutter-specific debugging (only override in Flutter projects)
          map('n', '<F9>', require('dap').toggle_breakpoint, 'Toggle Breakpoint')
          map('n', '<F10>', require('dap').step_over, 'Step Over')
          map('n', '<F11>', require('dap').step_into, 'Step Into')
          map('n', '<F12>', require('dap').step_out, 'Step Out')
          map('n', '<leader>dc', require('dap').continue, 'Continue')
          map('n', '<leader>dr', require('dap').repl.open, 'Open REPL')

          -- LSP restart (useful when LSP gets stuck)
          map('n', '<leader>fs', ':FlutterLspRestart<CR>', 'Restart LSP')
        end,
      })
    end,
  },

  -- Dart syntax highlighting
  {
    'dart-lang/dart-vim-plugin',
    ft = { 'dart' },
  },

  -- Pub.dev package search
  {
    'akinsho/pubspec-assist.nvim',
    ft = { 'yaml' },
    event = 'BufEnter pubspec.yaml',
    config = true,
  },
}

