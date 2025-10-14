return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff (Diffview)' },
      { '<leader>gD', '<cmd>DiffviewFileHistory<cr>', desc = 'Git File History' },
    },
    opts = {
      use_icons = true, -- Requires nvim-web-devicons for file icons
      enhanced_diff_hl = true,
      icons = { -- Only relevant if web-devicons is installed
        folder_closed = "",
        folder_open = "",
      },
      view = {
        default = {
          winbar = true,
        },
      },
      file_history_panel = {
        win_config = {
          width = 50,
        },
      },
    },
  },
}
