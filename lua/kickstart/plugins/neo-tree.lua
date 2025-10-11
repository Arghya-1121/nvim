-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
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
      filtered_items = {
        visible = true,
        hide_dotfiles = false, -- Show dotfiles (files starting with .)
        hide_gitignored = false, -- Show gitignored files
        hide_by_name = {
          -- You can still hide specific files/folders if needed
          -- ".DS_Store",
          -- "thumbs.db"
        },
        never_show = { -- Files that will never be shown
          ".git",
          ".idea",
          ".vscode",
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['H'] = 'toggle_hidden', -- Toggle hidden files visibility with 'H'
        },
      },
    },
  },
}
