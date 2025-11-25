return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'VeryLazy',
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
      -- keymaps
      vim.keymap.set('n', '<leader>ai', function()
        require('CopilotChat').toggle()
      end, { desc = 'Toggle AI panel' })
      vim.keymap.set('v', '<leader>ae', function()
        require('CopilotChat').ask('Explain this', { selection = true })
      end, { desc = 'Explain some piece of code' })
      vim.keymap.set('n', '<leader>ax', function()
        require('CopilotChat').reset()
      end, { desc = 'Reset copilot chat' })
      vim.keymap.set('n', '<leader>am', function()
        require('CopilotChat').select_model()
      end, { desc = 'Select model' })
    end,
  },
}
