local keymap = vim.keymap.set

-- LSP and Diagnostics
keymap('n', '<leader>i', function()
  vim.lsp.buf.hover()
end, { desc = 'Show LSP hover documentation' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- General
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys
keymap({ 'n', 'i', 'v' }, '<Left>', '<Nop>')
keymap({ 'n', 'i', 'v' }, '<Right>', '<Nop>')
keymap({ 'n', 'i', 'v' }, '<Up>', '<Nop>')
keymap({ 'n', 'i', 'v' }, '<Down>', '<Nop>')

-- Window Navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
keymap('n', '<C-q>', '<cmd>close<CR>', { desc = 'Unsplit window' })

-- Split Management
keymap('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
keymap('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Split window horizontally' })
keymap('n', '<leader>sq', '<cmd>close<CR>', { desc = 'Unsplit window' })

-- Window Resizing
keymap('n', '<C-A-h>', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
keymap('n', '<C-A-l>', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
keymap('n', '<C-A-j>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
keymap('n', '<C-A-k>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })

-- Snippet Tab Fix
keymap('i', '<Tab>', '<Tab>', { noremap = true })
keymap('s', '<Tab>', '<Tab>', { noremap = true })
keymap('i', '<S-Tab>', '<S-Tab>', { noremap = true })
keymap('s', '<S-Tab>', '<S-Tab>', { noremap = true })

-- Nativating in insert mode
vim.keymap.set({ 'i', 'c' }, '<M-h>', '<Left>')
vim.keymap.set({ 'i', 'c' }, '<M-l>', '<Right>')
vim.keymap.set({ 'i', 'c' }, '<M-j>', '<Down>')
vim.keymap.set({ 'i', 'c' }, '<M-k>', '<Up>')
vim.keymap.set({ 'i', 'c' }, '<M-w>', '<C-Right>')
vim.keymap.set({ 'i', 'c' }, '<M-b>', '<C-Left>')
