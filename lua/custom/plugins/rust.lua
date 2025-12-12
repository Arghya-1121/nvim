return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
            border = 'rounded',
          },
          inlay_hints = {
            only_current_line = false,
            show_parameter_hints = true,
            show_variable_type_hints = true,
          },
          -- Enable automatic reload on config changes
          reload_workspace_from_cargo_toml = true,
        },
        server = {
          on_attach = function(client, bufnr)
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Run project (F5)
            map('n', '<F5>', function()
              vim.cmd '!cargo run'
            end, 'Cargo Run')

            map('n', '<leader>rr', ':RustLsp runnables<CR>', 'Rust Runnables')
            map('n', '<leader>rd', ':RustLsp debuggables<CR>', 'Rust Debuggables')
            map('n', '<leader>rt', ':RustLsp testables<CR>', 'Rust Testables')
            map('n', '<leader>re', ':RustLsp expandMacro<CR>', 'Expand Macro')
            map('n', '<leader>rc', ':RustLsp openCargo<CR>', 'Open Cargo.toml')
            map('n', '<leader>rp', ':RustLsp parentModule<CR>', 'Parent Module')
            map('n', '<leader>rj', ':RustLsp joinLines<CR>', 'Join Lines')
            map('v', '<leader>rj', ':RustLsp joinLines<CR>', 'Join Lines')
            map('n', '<leader>ra', ':RustLsp hover actions<CR>', 'Hover Actions')
            map('n', '<leader>rh', ':RustLsp hover range<CR>', 'Hover Range')
            map('n', '<leader>rm', ':RustLsp rebuildProcMacros<CR>', 'Rebuild Proc Macros')
            map('n', '<leader>rw', ':RustLsp reloadWorkspace<CR>', 'Reload Workspace')

            map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')

            map('n', '<leader>cb', ':Cargo build<CR>', 'Cargo Build')
            map('n', '<F5>', ':Cargo run<CR>', 'Cargo Run')
            map('n', '<leader>ct', ':Cargo test<CR>', 'Cargo Test')
            map('n', '<leader>cc', ':Cargo check<CR>', 'Cargo Check')
            map('n', '<leader>cl', ':Cargo clippy<CR>', 'Cargo Clippy')
            map('n', '<leader>cu', ':Cargo update<CR>', 'Cargo Update')
            map('n', '<leader>cd', ':Cargo doc --open<CR>', 'Cargo Doc')

            -- Enable inlay hints by default
            vim.lsp.inlay_hint.enable(true)
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                autoimport = true,
                autoreload = true,
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = {
                enable = true,
                command = 'clippy',
                allFeatures = true,
              },
              procMacro = {
                enable = true,
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['napi-derive'] = { 'napi' },
                  ['async-recursion'] = { 'async_recursion' },
                },
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
                disabled = {},
              },
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { minLines = 10 },
                closureReturnTypeHints = { enable = 'always' },
                lifetimeElisionHints = { enable = 'always', useParameterNames = true },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = 'always' },
                renderColons = true,
                typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
              },
              lens = {
                enable = true,
                references = { adt = { enable = true }, enumVariant = { enable = true }, method = { enable = true }, trait = { enable = true } },
                run = { enable = true },
                debug = { enable = true },
                implementations = { enable = true },
              },
              completion = {
                callable = { snippets = 'fill_arguments' },
                postfix = { enable = true },
                autoimport = { enable = true },
                autoself = { enable = true },
              },
              assist = {
                importEnforceGranularity = true,
                importPrefix = 'by_crate',
              },
              hover = {
                actions = {
                  enable = true,
                  implementations = { enable = true },
                  references = { enable = true },
                  run = { enable = true },
                  debug = { enable = true },
                },
                documentation = { enable = true },
                links = { enable = true },
              },
            },
          },
        },
        dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(
            vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb',
            vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/lldb/lib/liblldb.so'
          ),
          configuration = {
            name = 'Launch',
            type = 'codelldb',
            request = 'launch',
            stopOnEntry = false,
            showDisassembly = 'never',
          },
        },
      }
    end,
  },
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup {
        popup = {
          border = 'rounded',
        },
      }

      local crates = require 'crates'
      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = 'Show Crate Versions' })
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = 'Show Crate Features' })
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, { desc = 'Show Crate Dependencies' })
      vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = 'Update Crate' })
      vim.keymap.set('v', '<leader>cu', crates.update_crates, { desc = 'Update Crates' })
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = 'Update All Crates' })
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, { desc = 'Upgrade Crate' })
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, { desc = 'Upgrade Crates' })
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, { desc = 'Upgrade All Crates' })
    end,
  },
}
