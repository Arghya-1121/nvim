return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          on_attach = function(_, _)
            -- You can add keymaps here later
          end,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = true,
          filter = nil,
          -- open_cmd = "15split | wincmd p", -- open and then go back to last window
          focus_on_open = false,
        },
        widget_guides = {
          enabled = true,
        },
        decorations = {
          statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true,
            -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
            -- this will show the currently selected project configuration
            project_config = true,
          },
        },
      })
      if vim.fn.expand("%:t") == "pubspec.yaml" then
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          callback = function()
            vim.cmd("FlutterPubGet")
          end,
        })
      end

      -- Optional keymaps for Flutter
      --      vim.keymap.set("n", "<leader>fr", ":FlutterHotReload<CR>", { desc = "Flutter Hot Reload" })
      vim.keymap.set("n", "<C-s>", ":FlutterReload<CR>", { desc = "Flutter Hot Reload", silent = true })
      vim.keymap.set("n", "<leader>fR", ":FlutterRestart<CR>", { desc = "Flutter Hot Restart" })
      vim.keymap.set("n", "<F5>", ":FlutterRun<CR>", { desc = "Flutter Run" })
      vim.keymap.set("n", "<F8>", "FlutterQuit", { desc = "Flutter Quit" })
      vim.keymap.set("n", "<leader>fL", ":FlutterLog<CR>", { desc = "Show Flutter Logs" })
      vim.keymap.set("n", "<leader>fl", ":FlutterDevices<CR>", { desc = "Flutter Devices" })
      vim.keymap.set("n", "<leader>fv", ":FlutterEmulators<CR>", { desc = "Flutter Emulators" })
      vim.keymap.set("n", "<leader>fD", ":FlutterDevTools<CR>", { desc = "Flutter Dev Tools" })
      vim.keymap.set("n", "<leader>fd", function()
        require("dapui").toggle()
      end, { desc = "Toggle Debugger UI" })
    end,
  },
}