return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle file [E]xplorer' },
  },
  opts = {
    window = {
      width = 30,
    },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        visible = true,
        hide_dotfiles = false, -- Show dotfiles (files starting with .)
        hide_gitignored = false,
        hide_by_name = {
          -- You can still hide specific files/folders if needed
          -- ".DS_Store",
          -- "thumbs.db"
        },
        never_show = {
          '.git',
          '.idea',
          '.vscode',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['H'] = 'toggle_hidden',
        },
      },
    },
  },
}
