return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>Rs', desc = 'Send request' },
    { '<leader>Ra', desc = 'Send all requests' },
    { '<leader>Rb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<leader>R',
    kulala_keymaps_prefix = '',
    ui = {
      display_mode = 'float',
    },
  },
  config = function(_, opts)
    require('kulala').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'json.kulala_ui',
      callback = function()
        vim.wo.foldenable = false
      end,
      desc = 'Disable folding for Kulala response buffer',
    })
  end,
}
