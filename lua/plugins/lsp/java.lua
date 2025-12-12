return {
  -- Kotlin Language Server
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        kotlin_language_server = {
          settings = {
            kotlin = {
              compiler = {
                jvm = {
                  target = '21',
                },
              },
              indexing = {
                enabled = true,
              },
              completion = {
                snippets = {
                  enabled = true,
                },
              },
              linting = {
                debounceTime = 300,
              },
            },
          },
        },
      },
    },
  },

  -- Treesitter support for Kotlin
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, {
          'java',
          'kotlin',
          'groovy', -- For Gradle build files
        })
      end
    end,
  },

  -- Java Language Server with Kotlin integration
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local jdtls = require 'jdtls'

      -- Paths
      local home = os.getenv 'HOME'
      local jdtls_root = home .. '/.local/share/nvim/mason/packages/jdtls'
      local lombok_path = jdtls_root .. '/lombok.jar'
      local launcher = vim.fn.glob(jdtls_root .. '/plugins/org.eclipse.equinox.launcher_*.jar')
      local config_dir = jdtls_root .. '/config_linux'

      -- Workspace folder
      local workspace = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

      -- Verify files exist
      if vim.fn.filereadable(lombok_path) ~= 1 then
        vim.notify('ERROR: Lombok not found at ' .. lombok_path, vim.log.levels.ERROR)
        return
      end
      if launcher == '' then
        vim.notify('ERROR: JDTLS launcher jar missing', vim.log.levels.ERROR)
        return
      end

      -- LSP settings
      local config = {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-javaagent:' .. lombok_path,
          '-jar',
          launcher,
          '-configuration',
          config_dir,
          '-data',
          workspace,
        },

        root_dir = require('jdtls.setup').find_root {
          '.git',
          'mvnw',
          'gradlew',
          'pom.xml',
          'build.gradle',
        },

        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = 'all', -- Show parameter names everywhere
                exclusions = { 'hashCode', 'equals' }, -- optional
              },
              parameterTypes = {
                enabled = true,
              },
              constructorParameterNames = {
                enabled = true,
              },
              methodParameterNames = {
                enabled = true,
              },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            import = { enabled = true },
            maven = { downloadSources = true },
            eclipse = { downloadSources = true },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-21',
                  path = '/usr/lib/jvm/java-21-openjdk/',
                },
              },
            },
          },
        },

        init_options = {
          bundles = {
            vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar', true),
          },
        },

        on_attach = function(client, bufnr)
          require('jdtls.dap').setup_dap_main_class_configs()

          -- Enable hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      }

      -- Auto-start JDTLS
      jdtls.start_or_attach(config)
    end,
  },

  -- Kotlin-specific keymaps and autocommands
  {
    'nvim-lua/plenary.nvim',
    config = function()
      -- Auto-detect Kotlin projects and set up keybindings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'kotlin',
        callback = function(event)
          local bufnr = event.buf
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Kotlin-specific commands
          map('n', '<leader>jkc', ':!kotlinc % -include-runtime -d %:r.jar<CR>', 'Compile Kotlin')
          map('n', '<leader>jkr', ':!kotlin %:r.jarKt<CR>', 'Run Kotlin')
          map('n', '<leader>jks', ':!kotlinc % && kotlin %:rKt<CR>', 'Compile & Run Kotlin Script')

          -- Gradle Kotlin DSL commands
          map('n', '<leader>jgkb', ':!./gradlew build<CR>', 'Gradle Build (Kotlin)')
          map('n', '<leader>jgkt', ':!./gradlew test<CR>', 'Gradle Test (Kotlin)')
          map('n', '<leader>jgkr', ':!./gradlew run<CR>', 'Gradle Run (Kotlin)')
        end,
      })

      -- Auto-detect build system and set appropriate commands
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.java', '*.kt' },
        callback = function()
          local root = vim.fn.getcwd()
          local has_gradle = vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1
          local has_maven = vim.fn.filereadable(root .. '/pom.xml') == 1

          if has_gradle then
            vim.b.build_system = 'gradle'
          elseif has_maven then
            vim.b.build_system = 'maven'
          end
        end,
      })
    end,
  },

  -- Optional: Add Java/Kotlin test runner
  {
    'rcasia/neotest-java',
    ft = { 'java', 'kotlin' },
    dependencies = {
      'nvim-neotest/neotest',
      'mfussenegger/nvim-jdtls',
    },
  },

  -- Gradle and Maven file syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, {
          'groovy', -- For build.gradle
          'kotlin', -- For build.gradle.kts
        })
      end
    end,
  },

  -- Spring Boot development tools (conditional keybindings)
  -- {
  --   'nvim-lua/plenary.nvim',
  --   config = function()
  --     -- Function to check if current project is Java/Kotlin/Spring Boot
  --     local function is_java_kotlin_project()
  --       local ok, result = pcall(function()
  --         local root = vim.fn.getcwd()
  --         local has_gradle = vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1
  --         local has_maven = vim.fn.filereadable(root .. '/pom.xml') == 1
  --         local has_src_main_java = vim.fn.isdirectory(root .. '/src/main/java') == 1
  --         local has_src_main_kotlin = vim.fn.isdirectory(root .. '/src/main/kotlin') == 1
  --
  --         return has_gradle or has_maven or has_src_main_java or has_src_main_kotlin
  --       end)
  --
  --       return ok and result or false
  --     end
  --
  --     -- Set up conditional keybindings
  --     vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'DirChanged' }, {
  --       callback = function()
  --         if is_java_kotlin_project() then
  --           -- Quick project commands (only for Java/Kotlin projects)
  --           vim.keymap.set('n', '<leader>jpi', '<cmd>!./gradlew dependencies<cr>', { desc = 'Show Project Dependencies' })
  --           vim.keymap.set('n', '<leader>jpt', '<cmd>!./gradlew tasks<cr>', { desc = 'Show Available Tasks' })
  --           vim.keymap.set('n', '<leader>jpw', '<cmd>!./gradlew wrapper --gradle-version latest<cr>', { desc = 'Update Gradle Wrapper' })
  --
  --           -- Spring Boot Actuator endpoints (if running locally)
  --           vim.keymap.set('n', '<leader>jsa', '<cmd>!curl -s http://localhost:8080/actuator/health | jq<cr>', { desc = 'Check App Health' })
  --           vim.keymap.set('n', '<leader>jse', '<cmd>!curl -s http://localhost:8080/actuator/env | jq<cr>', { desc = 'Show Environment' })
  --           vim.keymap.set('n', '<leader>jsb', '<cmd>!curl -s http://localhost:8080/actuator/beans | jq<cr>', { desc = 'Show Beans' })
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
