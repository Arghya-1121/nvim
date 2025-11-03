-- ============================================================================
-- Powerful Python Development Configuration for Neovim
-- Supports: Python 3.x, Django, Flask, FastAPI, Data Science, Testing
-- ============================================================================

-- Helper function to safely check if current project is a Python project
local function is_python_project()
  local ok, result = pcall(function()
    local root = vim.fn.getcwd()
    local has_requirements = vim.fn.filereadable(root .. '/requirements.txt') == 1
    local has_pyproject = vim.fn.filereadable(root .. '/pyproject.toml') == 1
    local has_setup_py = vim.fn.filereadable(root .. '/setup.py') == 1
    local has_pipfile = vim.fn.filereadable(root .. '/Pipfile') == 1
    local has_poetry = vim.fn.filereadable(root .. '/poetry.lock') == 1
    local has_venv = vim.fn.isdirectory(root .. '/venv') == 1 or vim.fn.isdirectory(root .. '/.venv') == 1

    return has_requirements or has_pyproject or has_setup_py or has_pipfile or has_poetry or has_venv
  end)

  return ok and result or false
end

return {
  -- ============================================================================
  -- Python LSP (Language Server Protocol)
  -- ============================================================================
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- Python LSP Server (pylsp)
      opts.servers.pylsp = {
        settings = {
          pylsp = {
            plugins = {
              -- Linting
              pyflakes = { enabled = false },
              pylint = { enabled = false },
              pycodestyle = { enabled = false },
              -- Use ruff instead
              ruff = { enabled = true },
              -- Formatting
              black = { enabled = true },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              -- Import sorting
              isort = { enabled = true },
              -- Type checking
              mypy = { enabled = true },
              -- Code completion
              jedi_completion = {
                enabled = true,
                fuzzy = true,
                include_params = true,
              },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_signature_help = { enabled = true },
              jedi_symbols = { enabled = true },
            },
          },
        },
      }
      return opts
    end,
  },

  -- ============================================================================
  -- Treesitter - Enhanced Syntax Highlighting
  -- ============================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, {
          'python',
          'rst',
          'toml',
          'requirements',
        })
      end
    end,
  },

  -- ============================================================================
  -- Formatting & Linting
  -- ============================================================================
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { 'isort', 'black' }
      return opts
    end,
  },

  {
    'mfussenegger/nvim-lint',
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { 'ruff', 'mypy' }
      return opts
    end,
  },

  -- ============================================================================
  -- Python Debugging (DAP)
  -- ============================================================================
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'
      -- Setup debugpy
      dap_python.setup 'python3'
      -- Python debug configurations
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            -- Try to find virtual environment python
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file with arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input 'Arguments: '
            return vim.split(args_string, ' +')
          end,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Django',
          program = '${workspaceFolder}/manage.py',
          args = { 'runserver' },
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Flask',
          module = 'flask',
          env = {
            FLASK_APP = 'app.py',
            FLASK_DEBUG = '1',
          },
          args = { 'run', '--no-debugger', '--no-reload' },
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'launch',
          name = 'FastAPI',
          module = 'uvicorn',
          args = { 'main:app', '--reload' },
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Pytest',
          module = 'pytest',
          args = { '${file}', '-v' },
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return 'python3'
            end
          end,
          console = 'integratedTerminal',
        },
      }
    end,
  },

  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = { 'mfussenegger/nvim-dap' },
  },

  -- ============================================================================
  -- Testing Support (Pytest)
  -- ============================================================================
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    ft = 'python',
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            args = { '--log-level', 'DEBUG', '-v' },
            runner = 'pytest',
            python = function()
              local cwd = vim.fn.getcwd()
              if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
              elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
              else
                return 'python3'
              end
            end,
          },
        },
      }
    end,
  },

  -- ============================================================================
  -- Virtual Environment Selector
  -- ============================================================================
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    ft = 'python',
    opts = {
      name = { 'venv', '.venv', 'env', '.env' },
      auto_refresh = true,
    },
    keys = {
      { '<leader>pv', '<cmd>VenvSelect<cr>', desc = 'Select Python Virtual Environment' },
    },
  },

  -- ============================================================================
  -- Documentation & Docstrings
  -- ============================================================================
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = 'python',
    opts = {
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = 'google',
          },
        },
      },
    },
    keys = {
      { '<leader>pd', '<cmd>Neogen<cr>', desc = 'Generate Docstring' },
    },
  },

  -- ============================================================================
  -- REPL Integration
  -- ============================================================================
  {
    'Vigemus/iron.nvim',
    ft = 'python',
    config = function()
      require('iron.core').setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { 'python3' },
              format = require('iron.fts.common').bracketed_paste_python,
            },
          },
          repl_open_cmd = require('iron.view').bottom(10),
        },
        keymaps = {
          send_motion = '<leader>pm',
          visual_send = '<leader>ps',
          send_line = '<leader>pl',
          send_mark = '<leader>pM',
          send_until_cursor = '<leader>pu',
          cr = '<leader>p<cr>',
          interrupt = '<leader>p<space>',
          exit = '<leader>pq',
          clear = '<leader>pc',
        },
      }
    end,
  },

  -- ============================================================================
  -- Which-Key Integration
  -- ============================================================================
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      if is_python_project() then
        opts.spec = opts.spec or {}
        table.insert(opts.spec, { '<leader>p', group = '[P]ython Development' })
        table.insert(opts.spec, { '<leader>pt', group = '[T]est' })
        table.insert(opts.spec, { '<leader>pr', group = '[R]un' })
      end
      return opts
    end,
  },

  -- ============================================================================
  -- Python Keymaps (Context-Aware)
  -- ============================================================================
  {
    'nvim-lua/plenary.nvim',
    config = function()
      -- Set up conditional keybindings for Python projects
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'DirChanged' }, {
        pattern = '*.py',
        callback = function()
          if is_python_project() then
            local map = vim.keymap.set
            local opts = { silent = true, buffer = true }

            -- Running Python
            map('n', '<leader>prr', '<cmd>!python3 %<cr>', vim.tbl_extend('force', opts, { desc = 'Run current file' }))
            map('n', '<leader>prp', function()
              local file = vim.fn.expand '%:p'
              local term_cmd = string.format("split | terminal python3 '%s'", file)
              vim.cmd(term_cmd)
            end, vim.tbl_extend('force', opts, { desc = 'Run in split terminal' }))

            -- Testing
            map('n', '<leader>ptr', '<cmd>lua require("neotest").run.run()<cr>', vim.tbl_extend('force', opts, { desc = 'Run nearest test' }))
            map('n', '<leader>ptf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', vim.tbl_extend('force', opts, { desc = 'Run file tests' }))
            map('n', '<leader>pts', '<cmd>lua require("neotest").summary.toggle()<cr>', vim.tbl_extend('force', opts, { desc = 'Toggle test summary' }))
            map(
              'n',
              '<leader>pto',
              '<cmd>lua require("neotest").output.open({ enter = true })<cr>',
              vim.tbl_extend('force', opts, { desc = 'Show test output' })
            )
            map(
              'n',
              '<leader>ptd',
              '<cmd>lua require("neotest").run.run({strategy = "dap"})<cr>',
              vim.tbl_extend('force', opts, { desc = 'Debug nearest test' })
            )

            -- Virtual Environment
            map('n', '<leader>pv', '<cmd>VenvSelect<cr>', vim.tbl_extend('force', opts, { desc = 'Select venv' }))

            -- Debugging
            map('n', '<leader>pdb', '<cmd>lua require("dap").toggle_breakpoint()<cr>', vim.tbl_extend('force', opts, { desc = 'Toggle breakpoint' }))
            map('n', '<leader>pdc', '<cmd>lua require("dap").continue()<cr>', vim.tbl_extend('force', opts, { desc = 'Continue/Start debug' }))
            map('n', '<leader>pdn', '<cmd>lua require("dap").step_over()<cr>', vim.tbl_extend('force', opts, { desc = 'Step over' }))
            map('n', '<leader>pdi', '<cmd>lua require("dap").step_into()<cr>', vim.tbl_extend('force', opts, { desc = 'Step into' }))
            map('n', '<leader>pdo', '<cmd>lua require("dap").step_out()<cr>', vim.tbl_extend('force', opts, { desc = 'Step out' }))

            -- REPL
            map('n', '<leader>pi', '<cmd>IronRepl<cr>', vim.tbl_extend('force', opts, { desc = 'Open Python REPL' }))
            map('n', '<leader>pr', '<cmd>IronRestart<cr>', vim.tbl_extend('force', opts, { desc = 'Restart REPL' }))

            -- Pip commands
            map('n', '<leader>pir', '<cmd>!pip3 install -r requirements.txt<cr>', vim.tbl_extend('force', opts, { desc = 'Install requirements' }))
            map('n', '<leader>pif', '<cmd>!pip3 freeze > requirements.txt<cr>', vim.tbl_extend('force', opts, { desc = 'Freeze requirements' }))

            -- Linting/Formatting
            map('n', '<leader>plr', '<cmd>!ruff check %<cr>', vim.tbl_extend('force', opts, { desc = 'Run ruff' }))
            map('n', '<leader>plm', '<cmd>!mypy %<cr>', vim.tbl_extend('force', opts, { desc = 'Run mypy' }))
          end
        end,
      })
    end,
  },

  -- ============================================================================
  -- Python Snippets
  -- ============================================================================
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Custom Python snippets
      local ls = require 'luasnip'
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets('python', {
        s('main', {
          t { 'def main():', '    ' },
          i(1, 'pass'),
          t { '', '', '', 'if __name__ == "__main__":', '    main()' },
        }),
        s('class', {
          t 'class ',
          i(1, 'ClassName'),
          t { ':', '    def __init__(self, ' },
          i(2, 'args'),
          t { '):', '        ' },
          i(0),
        }),
        s('def', {
          t 'def ',
          i(1, 'function_name'),
          t '(',
          i(2, 'args'),
          t ') -> ',
          i(3, 'None'),
          t { ':', '    """' },
          i(4, 'Description'),
          t { '"""', '    ' },
          i(0),
        }),
        s('for', {
          t 'for ',
          i(1, 'item'),
          t ' in ',
          i(2, 'items'),
          t { ':', '    ' },
          i(0),
        }),
        s('try', {
          t { 'try:', '    ' },
          i(1, 'pass'),
          t { '', 'except ' },
          i(2, 'Exception'),
          t { ' as e:', '    ' },
          i(0, 'pass'),
        }),
      })
    end,
  },
}
