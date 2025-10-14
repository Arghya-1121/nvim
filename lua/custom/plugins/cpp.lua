return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {
          cmd = { 
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '--all-scopes-completion',
            '--cross-file-rename',
            '--query-driver=/usr/bin/g++,/usr/bin/gcc',
            '--log=verbose',
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern(
              'compile_commands.json',
              'compile_flags.txt',
              '.clangd',
              '.git'
            )(fname) or vim.fn.getcwd()
          end,
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          on_attach = function(client, bufnr)
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- C/C++ specific keymaps
            map("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", "Switch Source/Header")
            map("n", "<leader>ct", ":ClangdTypeHierarchy<CR>", "Type Hierarchy")
            map("n", "<leader>cs", ":ClangdSymbolInfo<CR>", "Symbol Info")
            map("n", "<leader>cm", ":ClangdMemoryUsage<CR>", "Memory Usage")
            map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
            
            -- Compilation commands
            map("n", "<F5>", ":!make run<CR>", "Make Run")
            map("n", "<leader>cb", ":!make build<CR>", "Make Build")
            map("n", "<leader>cc", ":!make clean<CR>", "Make Clean")
            map("n", "<leader>cm", ":!cmake -S . -B build<CR>", "CMake Configure")
            map("n", "<leader>cM", ":!cmake --build build<CR>", "CMake Build")
            
            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true)
            end
          end,
        },
      },
    },
  },

  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      
      -- C++ Debugger (cppdbg - Microsoft C/C++ extension)
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/bin/OpenDebugAD7',
      }
      
      -- GDB adapter (alternative)
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" }
      }
      
      -- LLDB adapter (alternative, better for modern C++)
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- Adjust path as needed
        name = 'lldb'
      }

      -- C++ configurations
      dap.configurations.cpp = {
        -- cppdbg configuration
        {
          name = 'Launch (cppdbg)',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = false,
          args = {},
          runInTerminal = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        -- GDB configuration
        {
          name = "Launch (GDB)",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        -- LLDB configuration (best for C++)
        {
          name = 'Launch (LLDB)',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        -- Attach to process
        {
          name = "Attach to process (cppdbg)",
          type = "cppdbg",
          request = "attach",
          processId = require('dap.utils').pick_process,
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
      }
      
      -- C configurations (same as C++)
      dap.configurations.c = dap.configurations.cpp
      
      -- Debugging keymaps
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Step Over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Step Into' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Step Out' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
      vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Run Last' })
    end,
    dependencies = {
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'rcarriga/nvim-dap-ui',
    },
  },

  -- CMake integration
  {
    'Civitasv/cmake-tools.nvim',
    lazy = true,
    ft = { 'c', 'cpp', 'cmake' },
    config = function()
      require('cmake-tools').setup({
        cmake_command = "cmake",
        cmake_build_directory = "build",
        cmake_build_directory_prefix = "",
        cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_console_size = 10,
        cmake_show_console = "always",
        cmake_dap_configuration = {
          name = "cpp",
          type = "cppdbg",
          request = "launch"
        },
      })
      
      -- CMake keymaps
      vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>', { desc = 'CMake Generate' })
      vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { desc = 'CMake Build' })
      vim.keymap.set('n', '<leader>cr', ':CMakeRun<CR>', { desc = 'CMake Run' })
      vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>', { desc = 'CMake Debug' })
      vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildType<CR>', { desc = 'CMake Build Type' })
      vim.keymap.set('n', '<leader>cT', ':CMakeSelectBuildTarget<CR>', { desc = 'CMake Build Target' })
      vim.keymap.set('n', '<leader>cC', ':CMakeClean<CR>', { desc = 'CMake Clean' })
    end,
  },

  -- C/C++ header guard generator
  {
    'drmikehenry/vim-headerguard',
    lazy = true,
    ft = { 'c', 'cpp' },
    config = function()
      vim.g.headerguard_use_cpp_comments = 1
      vim.keymap.set('n', '<leader>hg', ':HeaderguardAdd<CR>', { desc = 'Add Header Guard' })
    end,
  },
}