return {
  'AntonVanAssche/music-controls.nvim',
  event = 'VeryLazy',
  vim.keymap.set('n', '<leader>xx', ':MPlayers<CR>', { noremap = true, silent = true, desc = 'Displays a list of available music players.' }),
  vim.keymap.set('n', '<leader>xp', ':MPlay<CR>', { noremap = true, silent = true, desc = 'Toggle play/pause the current track.' }),
  vim.keymap.set('n', '<leader>xn', ':MNext<CR>', { noremap = true, silent = true, desc = 'Play the next track.' }),
  vim.keymap.set('n', '<leader>xo', ':MPrev<CR>', { noremap = true, silent = true, desc = 'Play the previous track.' }),
  vim.keymap.set('n', '<leader>xc', ':MCurrent<CR>', { noremap = true, silent = true, desc = 'Displays the current track playing. ' }),
  vim.keymap.set('n', '<leader>xs', ':MShuffle<CR>', { noremap = true, silent = true, desc = 'Toggle shuffle mode.' }),
  vim.keymap.set('n', '<leader>xl', ':MLoop ', { noremap = true, silent = true, desc = 'Set a loop mode(Track(default), None, Playlist).' }),
  vim.keymap.set('n', '<leader>xt', ':MLoopToggle<CR>', { noremap = true, silent = true, desc = 'Toggle loop mode between None and Track.' }),
  vim.keymap.set('n', '<leader>xvg', ':MVolumeGet<CR>', { noremap = true, silent = true, desc = 'Display the current volume as a percentage.' }),
  vim.keymap.set('n', '<leader>xvs', ':MVolumeSet ', { noremap = true, silent = true, desc = 'Set the volume to a specific value(0-1).' }),
}
