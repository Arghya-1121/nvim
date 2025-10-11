return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        dockerls = {
          filetypes = { 'dockerfile' },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                -- Docker Compose Schema for validation
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
                  'docker-compose.yml',
                  'docker-compose.yaml',
                },
              },
              validate = true,
              hover = true,
              completion = true,
            },
          },
        },
      },
    },
  },
  { 'ekalinin/Dockerfile.vim', ft = 'dockerfile' },
}

