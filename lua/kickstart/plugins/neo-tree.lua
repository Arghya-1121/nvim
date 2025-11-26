return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cmd = 'Neotree',
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute { reveal, source = 'filesystem' }
      end,
      desc = 'NeoTree reveal',
      silent = true,
    },
    -- {
    --   '<leader>e',
    --   function()
    --     require('neo-tree.command').execute { toggle = true, source = 'filesystem' }
    --   end,
    --   desc = 'Toggle file explorer',
    -- },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    window = { width = 30 },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {},
        never_show = { '.git', '.idea', '.vscode' },
      },
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',
          ['h'] = 'toggle_hidden',
        },
      },
    },
  },
}
