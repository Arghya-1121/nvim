return {
  -- Enhanced TypeScript/JavaScript support for backend development
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    opts = {
      on_attach = function(client, bufnr)
        -- Disable tsserver's formatting in favor of prettier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Enhanced JavaScript/TypeScript/JSON support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "javascript",
          "typescript",
          "tsx",
          "json",
          "yaml",
          "toml",
          "dockerfile",
        })
      end
    end,
  },

  -- Prettier formatting for JS/TS files
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      return opts
    end,
  },

  -- ESLint linting for JS/TS files
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.javascript = { "eslint_d" }
      opts.linters_by_ft.typescript = { "eslint_d" }
      opts.linters_by_ft.javascriptreact = { "eslint_d" }
      opts.linters_by_ft.typescriptreact = { "eslint_d" }
      return opts
    end,
  },

  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = "json",
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048",
          outdated = "#d19a66",
        },
        icons = {
          enable = true,
          style = {
            up_to_date = "|  ",
            outdated = "|  ",
          },
        },
        autostart = true,
        hide_up_to_date = false,
        hide_unstable_versions = false,
      })
    end,
  },

  -- LSP Configuration for Node.js/Backend development
  {
    "neovim/nvim-lspconfig",
    opts = function()
      return {
        servers = {
          -- Basic TypeScript server (fallback if typescript-tools doesn't work)
          tsserver = {},
          -- JSON LSP with schema validation for package.json, tsconfig.json, etc.
          jsonls = {
            settings = {
              json = {
                schemas = pcall(require, "schemastore") and require("schemastore").json.schemas() or {},
                validate = { enable = true },
              },
            },
          },
          -- ESLint for JavaScript/TypeScript linting
          eslint = {
            settings = {
              workingDirectory = { mode = "auto" },
            },
          },
        },
      }
    end,
    dependencies = {
      "b0o/schemastore.nvim",
    },
  },

  -- JSON schemas for better validation
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Node.js specific keymaps
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>n", group = "[N]ode.js Development" },
        { "<leader>np", group = "[P]ackage" },
        { "<leader>nt", group = "[T]ypeScript" },
      },
    },
  },

  -- Node.js development specific keymaps and commands
  {
    "nvim-lua/plenary.nvim",
    keys = {
      -- Package.json commands
      { "<leader>npu", function() require("package-info").update() end, desc = "Update package", ft = "json" },
      { "<leader>npd", function() require("package-info").delete() end, desc = "Delete package", ft = "json" },
      { "<leader>npi", function() require("package-info").install() end, desc = "Install package", ft = "json" },
      { "<leader>npc", function() require("package-info").change_version() end, desc = "Change package version", ft = "json" },
      { "<leader>nps", function() require("package-info").show() end, desc = "Show package info", ft = "json" },

      -- TypeScript specific commands
      { "<leader>nto", "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize imports", ft = { "typescript", "javascript" } },
      { "<leader>nts", "<cmd>TSToolsSortImports<cr>", desc = "Sort imports", ft = { "typescript", "javascript" } },
      { "<leader>ntr", "<cmd>TSToolsRemoveUnused<cr>", desc = "Remove unused imports", ft = { "typescript", "javascript" } },
      { "<leader>ntf", "<cmd>TSToolsFixAll<cr>", desc = "Fix all issues", ft = { "typescript", "javascript" } },
      { "<leader>nta", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add missing imports", ft = { "typescript", "javascript" } },
      { "<leader>ntr", "<cmd>TSToolsRenameFile<cr>", desc = "Rename file", ft = { "typescript", "javascript" } },

      -- Node.js debugging and running
      { "<leader>nr", "<cmd>!node %<cr>", desc = "Run current JS file", ft = "javascript" },
      { "<leader>nt", "<cmd>!npx ts-node %<cr>", desc = "Run current TS file", ft = "typescript" },
      { "<leader>ni", "<cmd>!npm install<cr>", desc = "Run npm install" },
      { "<leader>nb", "<cmd>!npm run build<cr>", desc = "Run npm build" },
      { "<leader>ns", "<cmd>!npm start<cr>", desc = "Run npm start" },
      { "<leader>nd", "<cmd>!npm run dev<cr>", desc = "Run npm dev" },
    },
  },

  -- Better JSON support
  {
    "gennaro-tedesco/nvim-jqx",
    ft = "json",
    keys = {
      { "<leader>nj", "<cmd>JqxList<cr>", desc = "Browse JSON with jq", ft = "json" },
    },
  },

  -- Environment variables support
  {
    "ShinKage/idris2-nvim",
    dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" },
    ft = { "javascript", "typescript" },
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { ".env*", "*.env" },
        callback = function()
          vim.bo.filetype = "sh"
        end,
      })
    end,
  },

  -- Enhanced folding for JS/TS files
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    ft = { "javascript", "typescript", "json" },
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}