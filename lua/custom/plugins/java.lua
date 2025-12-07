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
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'williamboman/mason.nvim',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local jdtls = require 'jdtls'
      local home = os.getenv 'HOME'
      local jdtls_path = home .. '/.local/share/nvim/mason/packages/jdtls'
      local workspace_folder = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

      local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'settings.gradle' }
      local root_dir = require('jdtls.setup').find_root(root_markers)
      if root_dir == nil then
        return
      end

      -- Extended capabilities for better completion
      local extendedClientCapabilities = jdtls.extendedClientCapabilities
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

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
          '-jar',
          vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
          '-configuration',
          jdtls_path .. '/config_linux',
          '-data',
          workspace_folder,
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
                url = vim.fn.stdpath 'config' .. '/lang-servers/intellij-java-google-style.xml',
                profile = 'GoogleStyle',
              },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
              filteredTypes = {
                'com.sun.*',
                'io.micrometer.shaded.*',
                'java.awt.*',
                'jdk.*',
                'sun.*',
              },
              importOrder = {
                'java',
                'javax',
                'com',
                'org',
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
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
              },
              useBlocks = true,
            },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-21',
                  path = '/usr/lib/jvm/java-21-openjdk/',
                  default = true,
                },
              },
            },
          },
        },

        init_options = {
          bundles = (function()
            local bundles = {
              vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar', true),
            }
            vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', true), '\n'))
            return bundles
          end)(),
          extendedClientCapabilities = extendedClientCapabilities,
        },

        flags = {
          allow_incremental_sync = true,
        },

        on_attach = function(client, bufnr)
          require('jdtls.setup').add_commands()
          require('jdtls.dap').setup_dap_main_class_configs()

          -- Enable inlay hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Java specific commands
          map('n', '<leader>jo', jdtls.organize_imports, 'Organize Imports')
          map('n', '<leader>jv', jdtls.extract_variable, 'Extract Variable')
          map('v', '<leader>jv', [[<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>]], 'Extract Variable')
          map('n', '<leader>jc', jdtls.extract_constant, 'Extract Constant')
          map('v', '<leader>jc', [[<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>]], 'Extract Constant')
          map('v', '<leader>jm', [[<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>]], 'Extract Method')

          -- Testing
          map('n', '<leader>jt', jdtls.test_class, 'Test Class')
          map('n', '<leader>jn', jdtls.test_nearest_method, 'Test Nearest Method')

          -- Code actions
          map('n', '<leader>ja', vim.lsp.buf.code_action, 'Code Action')
          map('v', '<leader>ja', vim.lsp.buf.code_action, 'Code Action')

          -- Build commands (Maven)
          map('n', '<leader>jmb', ':!mvn clean install<CR>', 'Maven Build')
          map('n', '<leader>jmr', ':!mvn spring-boot:run<CR>', 'Maven Run')
          map('n', '<leader>jmt', ':!mvn test<CR>', 'Maven Test')
          map('n', '<leader>jmc', ':!mvn clean<CR>', 'Maven Clean')
          map('n', '<leader>jmp', ':!mvn package<CR>', 'Maven Package')

          -- Build commands (Gradle)
          map('n', '<leader>jgb', ':!./gradlew build<CR>', 'Gradle Build')
          map('n', '<leader>jgr', ':!./gradlew bootRun<CR>', 'Gradle Run')
          map('n', '<leader>jgt', ':!./gradlew test<CR>', 'Gradle Test')
          map('n', '<leader>jgc', ':!./gradlew clean<CR>', 'Gradle Clean')
          map('n', '<leader>jgk', ':!./gradlew compileKotlin<CR>', 'Gradle Compile Kotlin')
          map('n', '<leader>jgj', ':!./gradlew jar<CR>', 'Gradle JAR')

          -- Spring Boot specific
          map('n', '<leader>jsb', ':!./gradlew bootRun<CR>', 'Spring Boot Run (Gradle)')
          map('n', '<leader>jsm', ':!mvn spring-boot:run<CR>', 'Spring Boot Run (Maven)')
          map('n', '<leader>jsd', ':!./gradlew bootRun --debug-jvm<CR>', 'Spring Boot Debug')
          map('n', '<leader>jsp', ':!./gradlew bootJar && java -jar build/libs/*.jar<CR>', 'Spring Boot Production')

        end,
      }

      -- Auto-start jdtls for Java files
      local java_filetypes = { 'java' }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = java_filetypes,
        callback = function()
          jdtls.start_or_attach(config)
        end,
      })
    end,
  },

  -- Dynamic which-key groups for Java/Kotlin (only show in Java/Kotlin projects)
  {
    'folke/which-key.nvim',
    config = function()
      -- Function to check if current project is Java/Kotlin
      local function is_java_kotlin_project()
        local ok, result = pcall(function()
          local root = vim.fn.getcwd()
          local has_gradle = vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1
          local has_maven = vim.fn.filereadable(root .. '/pom.xml') == 1
          local has_src_main_java = vim.fn.isdirectory(root .. '/src/main/java') == 1
          local has_src_main_kotlin = vim.fn.isdirectory(root .. '/src/main/kotlin') == 1

          return has_gradle or has_maven or has_src_main_java or has_src_main_kotlin
        end)

        return ok and result or false
      end

      -- Only register Java/Kotlin which-key groups when in a Java/Kotlin project
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'DirChanged' }, {
        callback = function()
          if is_java_kotlin_project() then
            require('which-key').add {
              { '<leader>j', group = '[J]ava/Kotlin Development' },
              { '<leader>jm', group = '[M]aven' },
              { '<leader>jg', group = '[G]radle' },
              { '<leader>js', group = '[S]pring Boot' },
              { '<leader>jp', group = '[P]roject' },
            }
          end
        end,
      })
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
  {
    'nvim-lua/plenary.nvim',
    config = function()
      -- Function to check if current project is Java/Kotlin/Spring Boot
      local function is_java_kotlin_project()
        local ok, result = pcall(function()
          local root = vim.fn.getcwd()
          local has_gradle = vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1
          local has_maven = vim.fn.filereadable(root .. '/pom.xml') == 1
          local has_src_main_java = vim.fn.isdirectory(root .. '/src/main/java') == 1
          local has_src_main_kotlin = vim.fn.isdirectory(root .. '/src/main/kotlin') == 1

          return has_gradle or has_maven or has_src_main_java or has_src_main_kotlin
        end)

        return ok and result or false
      end

      -- Set up conditional keybindings
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'DirChanged' }, {
        callback = function()
          if is_java_kotlin_project() then
            -- Quick project commands (only for Java/Kotlin projects)
            vim.keymap.set('n', '<leader>jpi', '<cmd>!./gradlew dependencies<cr>', { desc = 'Show Project Dependencies' })
            vim.keymap.set('n', '<leader>jpt', '<cmd>!./gradlew tasks<cr>', { desc = 'Show Available Tasks' })
            vim.keymap.set('n', '<leader>jpw', '<cmd>!./gradlew wrapper --gradle-version latest<cr>', { desc = 'Update Gradle Wrapper' })

            -- Spring Boot Actuator endpoints (if running locally)
            vim.keymap.set('n', '<leader>jsa', '<cmd>!curl -s http://localhost:8080/actuator/health | jq<cr>', { desc = 'Check App Health' })
            vim.keymap.set('n', '<leader>jse', '<cmd>!curl -s http://localhost:8080/actuator/env | jq<cr>', { desc = 'Show Environment' })
            vim.keymap.set('n', '<leader>jsb', '<cmd>!curl -s http://localhost:8080/actuator/beans | jq<cr>', { desc = 'Show Beans' })
          end
        end,
      })
    end,
  },
}

