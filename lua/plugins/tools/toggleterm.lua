return {
  {
    'akinsho/toggleterm.nvim',
    config = true,
    cmd = 'ToggleTerm',
    keys = {
      { '<C-\\>', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
      { '<C-\\>', [[<C-\><C-n><cmd>ToggleTerm direction=float<cr>]], mode = 't', desc = 'Toggle floating terminal (from terminal)' },
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
      { '<leader>tf', [[<C-\><C-n><cmd>ToggleTerm direction=float<cr>]], mode = 't', desc = 'Toggle floating terminal (from terminal)' },
      { '<leader>th', '<cmd>2ToggleTerm size=15 direction=horizontal<cr>', desc = 'Toggle horizontal terminal' },
      { '<leader>th', [[<leader>tt<C-n><cmd>2ToggleTerm size=15 direction=horizontal<cr>]], mode = 't', desc = 'Toggle horizontal terminal (from terminal)' },
      { '<leader>tt', '<cmd>terminal<cr>', desc = 'Toggle Terminal as a new buffer' },
    },
    opts = {
      direction = 'float',
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
    },
  },
}
