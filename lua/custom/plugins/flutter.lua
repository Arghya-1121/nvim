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
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('flutter-tools').setup({
        ui = { 
          border = "rounded", 
          notification_style = "native" 
        },
        decorations = { 
          statusline = { 
            app_version = true, 
            device = true,
            project_config = true,
          } 
        },
        dev_log = { 
          enabled = true, 
          notify_errors = false,
          open_cmd = "tabedit",
        },
        widget_guides = { enabled = true },
        closing_tags = { 
          highlight = "Comment", 
          prefix = "// ", 
          enabled = true 
        },
        lsp = {
          color = { 
            enabled = true, 
            background = false, 
            virtual_text = true 
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            enableSdkFormatter = false,
            renameFilesWithClasses = "prompt",
            lineLength = 100,
            enableCompletionCommitCharacters = false, -- Prevents range errors
            analysisExcludedFolders = {
              "${workspaceRoot}/.dart_tool/",
              "${workspaceRoot}/.idea/",
              "${workspaceRoot}/.vscode/",
              "${workspaceRoot}/build/",
              "${workspaceRoot}/android/",
              "${workspaceRoot}/ios/",
              "${workspaceRoot}/windows/",
              "${workspaceRoot}/linux/",
              "${workspaceRoot}/macos/",
            },
          },
          on_attach = function(client, bufnr)
            -- Disable problematic LSP features
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            
            -- Add LSP capabilities for CMP
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, capabilities)
            
            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true)
            end

            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end

            -- Flutter specific keymaps
            map("n", "<leader>fa", vim.lsp.buf.code_action, "Code Action")
            map("v", "<leader>fa", vim.lsp.buf.code_action, "Code Action")
            map("n", "<leader>fr", vim.lsp.buf.rename, "Rename")
            map("n", "<leader>ff", vim.lsp.buf.format, "Format")
            
            -- Hot reload/restart
            map("n", "<C-s>", ":FlutterReload<CR>", "Hot Reload")
            map("n", "<leader>fR", ":FlutterRestart<CR>", "Hot Restart")
            
            -- Widget helpers
            map("n", "<leader>fw", ":FlutterOutlineToggle<CR>", "Widget Outline")
            map("n", "<leader>fW", ":FlutterOutlineOpen<CR>", "Open Outline")
          end,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          register_configurations = function(paths)
            local dap = require("dap")
            dap.adapters.dart = {
              type = "executable",
              command = "dart",
              args = { "debug_adapter" }
            }
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter (Profile)",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
                toolArgs = { "--profile" },
              },
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter Tests",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/test",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
      })

      -- Auto pub get on pubspec.yaml save
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "pubspec.yaml",
        callback = function()
          vim.cmd("FlutterPubGet")
        end,
      })

      -- Keymaps
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- Run/Stop
      map("n", "<F5>", ":FlutterRun<CR>", "Flutter Run")
      map("n", "<F6>", ":FlutterRun --flavor development -t lib/main_dev.dart<CR>", "Flutter Run Dev")
      map("n", "<F7>", ":FlutterRun --flavor production -t lib/main_prod.dart<CR>", "Flutter Run Prod")
      map("n", "<F8>", ":FlutterQuit<CR>", "Flutter Quit")
      
      -- Device management
      map("n", "<leader>fd", ":FlutterDevices<CR>", "Flutter Devices")
      map("n", "<leader>fe", ":FlutterEmulators<CR>", "Flutter Emulators")
      
      -- Development tools
      map("n", "<leader>fD", ":FlutterDevTools<CR>", "Flutter DevTools")
      map("n", "<leader>fo", ":FlutterOutlineToggle<CR>", "Toggle Outline")
      
      -- Logs
      map("n", "<leader>fl", ":FlutterLogToggle<CR>", "Toggle Logs")
      map("n", "<leader>fL", ":FlutterLogClear<CR>", "Clear Logs")
      
      -- Pub commands
      map("n", "<leader>fp", ":FlutterPubGet<CR>", "Pub Get")
      map("n", "<leader>fP", ":FlutterPubUpgrade<CR>", "Pub Upgrade")
      map("n", "<leader>fu", ":!flutter pub outdated<CR>", "Pub Outdated")
      
      -- Build commands
      map("n", "<leader>fb", ":!flutter build apk<CR>", "Build APK")
      map("n", "<leader>fB", ":!flutter build appbundle<CR>", "Build AAB")
      map("n", "<leader>fi", ":!flutter build ios<CR>", "Build iOS")
      map("n", "<leader>fI", ":!flutter build ipa<CR>", "Build IPA")
      map("n", "<leader>fw", ":!flutter build web<CR>", "Build Web")
      
      -- Testing
      map("n", "<leader>ft", ":!flutter test<CR>", "Run Tests")
      map("n", "<leader>fT", ":!flutter test --coverage<CR>", "Test with Coverage")
      
      -- Clean/Analyze
      map("n", "<leader>fc", ":!flutter clean<CR>", "Flutter Clean")
      map("n", "<leader>fA", ":!flutter analyze<CR>", "Flutter Analyze")
      map("n", "<leader>fF", ":!dart format .<CR>", "Dart Format")
      
      -- Code generation
      map("n", "<leader>fg", ":!flutter pub run build_runner build --delete-conflicting-outputs<CR>", "Build Runner")
      map("n", "<leader>fG", ":!flutter pub run build_runner watch --delete-conflicting-outputs<CR>", "Build Runner Watch")
      
      -- Debugging
      map("n", "<F9>", require("dap").toggle_breakpoint, "Toggle Breakpoint")
      map("n", "<F10>", require("dap").step_over, "Step Over")
      map("n", "<F11>", require("dap").step_into, "Step Into")
      map("n", "<F12>", require("dap").step_out, "Step Out")
      map("n", "<leader>du", function()
        require("dapui").toggle()
      end, "Toggle Debug UI")
      map("n", "<leader>dc", require("dap").continue, "Continue")
      map("n", "<leader>dr", require("dap").repl.open, "Open REPL")
      
      -- LSP restart (useful when LSP gets stuck)
      map("n", "<leader>fs", ":FlutterLspRestart<CR>", "Restart LSP")
    end,
  },
  
  -- Dart syntax highlighting
  {
    "dart-lang/dart-vim-plugin",
    ft = { "dart" },
  },
  
  -- Pub.dev package search
  {
    "akinsho/pubspec-assist.nvim",
    ft = { "yaml" },
    event = "BufEnter pubspec.yaml",
    config = true,
  },
}