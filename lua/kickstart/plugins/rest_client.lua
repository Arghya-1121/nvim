return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<F2>s', desc = 'Send request' },
    { '<F2>a', desc = 'Send all requests' },
    { '<F2>b', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<F2>',
    kulala_keymaps_prefix = '',
    ui = {
      display_mode = 'float',
      show_request_summary = true,
      scratchpad_default_contents = {
        '@MY_TOKEN_NAME=my_token_value',
        '',
        'GET http://localhost:8080/ HTTP/1.1',
        'accept: application/json',
        'content-type: application/json',
        '',
        '{',
        '  "": ""',
        '}',
      },
    },
  },
  config = function(_, opts)
    require('kulala').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'kulala_result', 'kulala_ui', 'json', 'http', 'rest' },
      callback = function()
        vim.wo.foldenable = false
      end,
      desc = 'Disable ALL folding for kulala buffers',
    })
  end,
}
