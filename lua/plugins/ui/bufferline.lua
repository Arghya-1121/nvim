return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      highlights = {
        buffer_selected = { italic = true },
        buffer_visible = { italic = false },
        buffer = { italic = false },
      },
      options = {
        mode = 'buffers',
        separator_style = 'slant',
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        numbers = 'ordinal',
        indicator = { style = 'none' },
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Explorer',
            highlight = 'Directory',
            text_align = 'center',
            separator = true,
          },
        },
        max_name_length = 14,
        max_prefix_length = 10,
        tab_size = 12,
        truncate_names = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = false,
      },
    }

    -- keymaps
    vim.keymap.set('n', ',1', '<Cmd>BufferLineGoToBuffer 1<CR>', { desc = 'GoTo buffer 1' })
    vim.keymap.set('n', ',2', '<Cmd>BufferLineGoToBuffer 2<CR>', { desc = 'GoTo buffer 2' })
    vim.keymap.set('n', ',3', '<Cmd>BufferLineGoToBuffer 3<CR>', { desc = 'GoTo buffer 3' })
    vim.keymap.set('n', ',4', '<Cmd>BufferLineGoToBuffer 4<CR>', { desc = 'GoTo buffer 4' })
    vim.keymap.set('n', ',5', '<Cmd>BufferLineGoToBuffer 5<CR>', { desc = 'GoTo buffer 5' })
    vim.keymap.set('n', ',6', '<Cmd>BufferLineGoToBuffer 6<CR>', { desc = 'GoTo buffer 6' })
    vim.keymap.set('n', ',7', '<Cmd>BufferLineGoToBuffer 7<CR>', { desc = 'GoTo buffer 7' })
    vim.keymap.set('n', ',8', '<Cmd>BufferLineGoToBuffer 8<CR>', { desc = 'GoTo buffer 8' })
    vim.keymap.set('n', ',9', '<Cmd>BufferLineGoToBuffer 9<CR>', { desc = 'GoTo buffer 9' })
    vim.keymap.set('n', ',<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'GoTo Next Buffer' })
    vim.keymap.set('n', ',<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'GoTo Previous Buffer' })
    vim.keymap.set('n', ',a', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Close all buffer except current one' })
    vim.keymap.set('n', ',p', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle Pin' })
  end,
}
