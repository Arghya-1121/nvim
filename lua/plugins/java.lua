return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    opts = {},
    config = function()
      local jdtls = require("jdtls")
      local home = os.getenv("HOME")
      local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
      local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == nil then
        return
      end

      local config = {
        cmd = {
          jdtls_path .. "/bin/jdtls",
          "--jvm-arg=-javaagent:" .. jdtls_path .. "/lombok.jar", -- optional, remove if not using lombok
          "-data",
          workspace_folder,
        },
        root_dir = root_dir,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk", -- adjust this if different
                },
              },
            },
          },
        },
        init_options = {
          bundles = {
            vim.fn.glob(
              home
                .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
              1
            ),
          },
        },
        on_attach = function(client, bufnr)
          require("jdtls.setup").add_commands()
          jdtls.setup_dap({ hotcodereplace = "auto" })
          jdtls.dap.setup_dap_main_class_configs()

          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>di", jdtls.organize_imports, opts)
          vim.keymap.set("n", "<leader>dt", jdtls.test_class, opts)
          vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
        end,
      }

      jdtls.start_or_attach(config)
    end,
  },

  -- Disable default jdtls setup from LazyVim
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = nil,
      },
    },
  },
}
