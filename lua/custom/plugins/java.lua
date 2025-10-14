return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local jdtls = require("jdtls")
      local home = os.getenv("HOME")
      local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
      local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == nil then
        return
      end

      -- Extended capabilities for better completion
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", jdtls_path .. "/config_linux",
          "-data", workspace_folder,
        },
        root_dir = root_dir,
        
        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              settings = {
                url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
                profile = "GoogleStyle",
              },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
              importOrder = {
                "java",
                "javax",
                "com",
                "org"
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
              },
              useBlocks = true,
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-11",
                  path = "/usr/lib/jvm/java-11-openjdk/",
                },
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk/",
                },
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk/",
                  default = true,
                },
              },
            },
          },
        },

        init_options = {
          bundles = (function()
            local bundles = {
              vim.fn.glob(
                home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar",
                true
              ),
            }
            vim.list_extend(
              bundles,
              vim.split(
                vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true),
                "\n"
              )
            )
            return bundles
          end)(),
          extendedClientCapabilities = extendedClientCapabilities,
        },

        flags = {
          allow_incremental_sync = true,
        },

        on_attach = function(client, bufnr)
          require("jdtls.setup").add_commands()
          require("jdtls.dap").setup_dap_main_class_configs()
          
          -- Enable inlay hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Java specific commands
          map("n", "<leader>jo", jdtls.organize_imports, "Organize Imports")
          map("n", "<leader>jv", jdtls.extract_variable, "Extract Variable")
          map("v", "<leader>jv", [[<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>]], "Extract Variable")
          map("n", "<leader>jc", jdtls.extract_constant, "Extract Constant")
          map("v", "<leader>jc", [[<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>]], "Extract Constant")
          map("v", "<leader>jm", [[<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>]], "Extract Method")
          
          -- Testing
          map("n", "<leader>jt", jdtls.test_class, "Test Class")
          map("n", "<leader>jn", jdtls.test_nearest_method, "Test Nearest Method")
          
          -- Code actions
          map("n", "<leader>ja", vim.lsp.buf.code_action, "Code Action")
          map("v", "<leader>ja", vim.lsp.buf.code_action, "Code Action")
          
          -- Build commands
          map("n", "<leader>jb", ":!mvn clean install<CR>", "Maven Build")
          map("n", "<leader>jB", ":!gradle build<CR>", "Gradle Build")
          map("n", "<leader>jr", ":!mvn spring-boot:run<CR>", "Maven Run")
          map("n", "<leader>jR", ":!gradle bootRun<CR>", "Gradle Run")
          map("n", "<leader>jC", ":!mvn clean<CR>", "Maven Clean")
          
          -- DAP keymaps
          map("n", "<F5>", require("dap").continue, "Debug Continue")
          map("n", "<F9>", require("dap").toggle_breakpoint, "Toggle Breakpoint")
          map("n", "<F10>", require("dap").step_over, "Step Over")
          map("n", "<F11>", require("dap").step_into, "Step Into")
          map("n", "<F12>", require("dap").step_out, "Step Out")
        end,
      }

      -- Auto-start jdtls for Java files
      local java_filetypes = { "java" }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = function()
          jdtls.start_or_attach(config)
        end,
      })
    end,
  },

  -- Optional: Add Java test runner
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "nvim-neotest/neotest",
      "mfussenegger/nvim-jdtls",
    },
  },
}