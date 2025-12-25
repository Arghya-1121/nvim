return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    -- event = 'InsertEnter', -- more optimize way to use this only if the ai code completion is being used
    cmd = { 'Copilot' },
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    cmd = { 'Copilot' },

    keys = {
      {
        '<leader>ai',
        function()
          require('CopilotChat').toggle()
        end,
        desc = 'Toggle AI panel',
      },
      {
        '<leader>ae',
        function()
          require('CopilotChat').ask('Explain this', { selection = true })
        end,
        mode = 'v',
        desc = 'Explain selection',
      },
      {
        '<leader>af',
        function()
          require('CopilotChat').ask('Fix this', { selection = true })
        end,
        mode = 'v',
        desc = 'Fix selection',
      },
      {
        '<leader>ax',
        function()
          require('CopilotChat').reset()
        end,
        desc = 'Reset chat',
      },
      {
        '<leader>am',
        function()
          require('CopilotChat').select_model()
        end,
        desc = 'Select model',
      },
    },

    config = function()
      require('CopilotChat').setup {
        window = {
          layout = 'float',
          relative = 'editor',
          border = 'rounded',
          width = 0.88,
          height = 0.85,
        },
      }
    end,
  },
}
