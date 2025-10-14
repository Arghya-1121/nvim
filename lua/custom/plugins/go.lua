return {
  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
          on_attach = function(client, bufnr)
            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true)
            end

            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end

            -- Go specific keymaps
            map("n", "<leader>ga", vim.lsp.buf.code_action, "Code Action")
            map("v", "<leader>ga", vim.lsp.buf.code_action, "Code Action")
            map("n", "<leader>gf", vim.lsp.buf.format, "Format")
            map("n", "<leader>gr", vim.lsp.buf.rename, "Rename")
            
            -- Go commands
            map("n", "<leader>gb", ":!go build<CR>", "Go Build")
            map("n", "<leader>gR", ":!go run .<CR>", "Go Run")
            map("n", "<leader>gt", ":!go test<CR>", "Go Test")
            map("n", "<leader>gT", ":!go test -v<CR>", "Go Test Verbose")
            map("n", "<leader>gc", ":!go test -cover<CR>", "Go Test Coverage")
            map("n", "<leader>gm", ":!go mod tidy<CR>", "Go Mod Tidy")
            map("n", "<leader>gi", ":!go get ", "Go Get")
            map("n", "<leader>gv", ":!go vet<CR>", "Go Vet")
            map("n", "<leader>gd", ":!go doc ", "Go Doc")
            map("n", "<leader>gB", ":!go build -race<CR>", "Go Build Race")
            map("n", "<leader>gC", ":!go clean<CR>", "Go Clean")
            
            -- Benchmark
            map("n", "<leader>gn", ":!go test -bench=.<CR>", "Go Benchmark")
          end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        },
      },
    },
  },

  -- Go tools integration
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        go = "go",
        goimport = "gopls",
        fillstruct = "gopls",
        gofmt = "gofumpt",
        max_line_len = 120,
        tag_transform = false,
        test_dir = "",
        comment_placeholder = "   ",
        lsp_cfg = false, -- Use lspconfig separately
        lsp_gofumpt = true,
        lsp_on_attach = false,
        dap_debug = true,
        dap_debug_gui = true,
        dap_debug_keymap = false,
        textobjects = true,
        luasnip = true,
        verbose = false,
      })

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- Go.nvim specific commands
      map("n", "<leader>gI", ":GoImport<CR>", "Go Import")
      map("n", "<leader>gA", ":GoAddTag<CR>", "Go Add Tag")
      map("n", "<leader>gD", ":GoRmTag<CR>", "Go Remove Tag")
      map("n", "<leader>gF", ":GoFillStruct<CR>", "Go Fill Struct")
      map("n", "<leader>gE", ":GoIfErr<CR>", "Go If Err")
      map("n", "<leader>gS", ":GoFillSwitch<CR>", "Go Fill Switch")
      map("n", "<leader>ge", ":GoGenerate<CR>", "Go Generate")
      map("n", "<leader>gM", ":GoModInit<CR>", "Go Mod Init")
      map("n", "<leader>gp", ":GoPkgOutline<CR>", "Go Package Outline")
      
      -- Testing helpers
      map("n", "<leader>gtf", ":GoTestFunc<CR>", "Go Test Function")
      map("n", "<leader>gtF", ":GoTestFile<CR>", "Go Test File")
      map("n", "<leader>gta", ":GoTest<CR>", "Go Test All")
      map("n", "<leader>gts", ":GoTestSum<CR>", "Go Test Summary")
      map("n", "<leader>gtc", ":GoCoverage<CR>", "Go Coverage")
      map("n", "<leader>gtC", ":GoCoverageClear<CR>", "Clear Coverage")
      
      -- Code generation
      map("n", "<leader>gj", ":GoJson2Struct<CR>", "JSON to Struct")
      map("n", "<leader>gw", ":GoWork<CR>", "Go Work")
    end,
  },

  -- DAP for Go
  {
    "mfussenegger/nvim-dap",
    ft = { "go" },
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })

      local dap = require("dap")
      
      -- Debugging keymaps
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end
      
      map("n", "<F5>", dap.continue, "Debug Continue")
      map("n", "<F9>", dap.toggle_breakpoint, "Toggle Breakpoint")
      map("n", "<F10>", dap.step_over, "Step Over")
      map("n", "<F11>", dap.step_into, "Step Into")
      map("n", "<F12>", dap.step_out, "Step Out")
      map("n", "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
      map("n", "<leader>dc", dap.continue, "Continue")
      map("n", "<leader>dr", dap.repl.open, "Open REPL")
      map("n", "<leader>dl", dap.run_last, "Run Last")
      
      -- Go specific debug
      map("n", "<leader>gdt", require("dap-go").debug_test, "Debug Test")
      map("n", "<leader>gdl", require("dap-go").debug_last_test, "Debug Last Test")
    end,
  },

  -- Treesitter for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
    end,
  },

  -- Go test runner
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    ft = { "go" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
          }),
        },
      })
      
      local neotest = require("neotest")
      vim.keymap.set("n", "<leader>gtn", neotest.run.run, { desc = "Run Nearest Test" })
      vim.keymap.set("n", "<leader>gtF", function() 
        neotest.run.run(vim.fn.expand("%")) 
      end, { desc = "Run Test File" })
      vim.keymap.set("n", "<leader>gtd", function()
        neotest.run.run({strategy = "dap"})
      end, { desc = "Debug Nearest Test" })
      vim.keymap.set("n", "<leader>gts", neotest.summary.toggle, { desc = "Toggle Test Summary" })
      vim.keymap.set("n", "<leader>gto", neotest.output.open, { desc = "Show Test Output" })
      vim.keymap.set("n", "<leader>gtO", neotest.output_panel.toggle, { desc = "Toggle Output Panel" })
    end,
  },
}