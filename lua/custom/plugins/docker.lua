return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        dockerls = {
          filetypes = { 'dockerfile' },
          root_dir = require('lspconfig').util.root_pattern('.git', 'Dockerfile', 'docker-compose.yml'),
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },
        docker_compose_language_service = {
          filetypes = { 'yaml.docker-compose' },
          root_dir = require('lspconfig').util.root_pattern('docker-compose.yml', 'docker-compose.yaml', 'compose.yml', 'compose.yaml'),
        },
        yamlls = {
          filetypes = { 'yaml', 'yaml.docker-compose' },
          settings = {
            yaml = {
              schemas = {
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
                  'docker-compose*.yml',
                  'docker-compose*.yaml',
                  'compose*.yml',
                  'compose*.yaml',
                },
                kubernetes = '*.yaml',
              },
              validate = true,
              hover = true,
              completion = true,
              format = {
                enable = true,
              },
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
            },
          },
        },
      },
    },
  },

  -- Better Dockerfile syntax
  {
    'ekalinin/Dockerfile.vim',
    ft = 'dockerfile',
  },

  -- Docker commands integration
  {
    'kkvh/vim-docker-tools',
    ft = { 'dockerfile', 'yaml.docker-compose' },
    config = function()
      vim.g.dockertools_default_all = 0
      vim.g.dockertools_default_dockerfile = 'Dockerfile'
      
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- Docker commands
      map('n', '<leader>db', ':!docker build -t %:t:r .<CR>', 'Docker Build')
      map('n', '<leader>dB', function()
        local tag = vim.fn.input('Tag name: ')
        vim.cmd('!docker build -t ' .. tag .. ' .')
      end, 'Docker Build (Custom Tag)')
      map('n', '<leader>dr', ':!docker run -it %:t:r<CR>', 'Docker Run')
      map('n', '<leader>dp', ':!docker ps<CR>', 'Docker PS')
      map('n', '<leader>dP', ':!docker ps -a<CR>', 'Docker PS All')
      map('n', '<leader>di', ':!docker images<CR>', 'Docker Images')
      map('n', '<leader>dl', ':!docker logs ', 'Docker Logs')
      map('n', '<leader>de', ':!docker exec -it ', 'Docker Exec')
      map('n', '<leader>ds', ':!docker stop ', 'Docker Stop')
      map('n', '<leader>dS', ':!docker start ', 'Docker Start')
      map('n', '<leader>dx', ':!docker rm ', 'Docker Remove Container')
      map('n', '<leader>dX', ':!docker rmi ', 'Docker Remove Image')
      
      -- Docker Compose commands
      map('n', '<leader>cu', ':!docker-compose up<CR>', 'Compose Up')
      map('n', '<leader>cd', ':!docker-compose up -d<CR>', 'Compose Up Detached')
      map('n', '<leader>cs', ':!docker-compose stop<CR>', 'Compose Stop')
      map('n', '<leader>cD', ':!docker-compose down<CR>', 'Compose Down')
      map('n', '<leader>cb', ':!docker-compose build<CR>', 'Compose Build')
      map('n', '<leader>cr', ':!docker-compose restart<CR>', 'Compose Restart')
      map('n', '<leader>cl', ':!docker-compose logs<CR>', 'Compose Logs')
      map('n', '<leader>cL', ':!docker-compose logs -f<CR>', 'Compose Logs Follow')
      map('n', '<leader>cp', ':!docker-compose ps<CR>', 'Compose PS')
      map('n', '<leader>ce', ':!docker-compose exec ', 'Compose Exec')
      map('n', '<leader>cP', ':!docker-compose pull<CR>', 'Compose Pull')
      map('n', '<leader>cU', ':!docker-compose up -d --build<CR>', 'Compose Up Build')
      
      -- Docker system commands
      map('n', '<leader>dC', ':!docker system prune -f<CR>', 'Docker Prune')
      map('n', '<leader>dv', ':!docker volume ls<CR>', 'Docker Volumes')
      map('n', '<leader>dn', ':!docker network ls<CR>', 'Docker Networks')
      map('n', '<leader>dI', ':!docker inspect ', 'Docker Inspect')
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'dockerfile', 'yaml' })
    end,
  },

  -- Auto-detect docker-compose files
  {
    'vim-scripts/vim-auto-save',
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { 'docker-compose*.yml', 'docker-compose*.yaml', 'compose*.yml', 'compose*.yaml' },
        callback = function()
          vim.bo.filetype = 'yaml.docker-compose'
        end,
      })
    end,
  },

  -- Snippets for Docker
  {
    'L3MON4D3/LuaSnip',
    optional = true,
    config = function()
      local ls = require('luasnip')
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets('dockerfile', {
        s('from', {
          t('FROM '),
          i(1, 'image:tag'),
          t({ '', '' }),
          t('WORKDIR '),
          i(2, '/app'),
        }),
        s('run', {
          t('RUN '),
          i(1, 'command'),
        }),
        s('copy', {
          t('COPY '),
          i(1, 'source'),
          t(' '),
          i(2, 'dest'),
        }),
        s('env', {
          t('ENV '),
          i(1, 'KEY'),
          t('='),
          i(2, 'value'),
        }),
        s('expose', {
          t('EXPOSE '),
          i(1, '8080'),
        }),
        s('cmd', {
          t('CMD ["'),
          i(1, 'command'),
          t('"]'),
        }),
        s('entrypoint', {
          t('ENTRYPOINT ["'),
          i(1, 'command'),
          t('"]'),
        }),
      })

      ls.add_snippets('yaml.docker-compose', {
        s('service', {
          t({ 'services:', '  ' }),
          i(1, 'app'),
          t({ ':', '    image: ' }),
          i(2, 'image:tag'),
          t({ '', '    ports:', '      - "' }),
          i(3, '8080'),
          t(':'),
          i(4, '8080'),
          t({ '"', '    environment:', '      - ' }),
          i(5, 'KEY=value'),
          t({ '', '    volumes:', '      - .:/app' }),
        }),
        s('volume', {
          t('volumes:'),
          t({ '', '  ' }),
          i(1, 'data'),
          t(':'),
        }),
        s('network', {
          t('networks:'),
          t({ '', '  ' }),
          i(1, 'default'),
          t({ ':', '    driver: bridge' }),
        }),
      })
    end,
  },
}