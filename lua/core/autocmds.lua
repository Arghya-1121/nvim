local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Large file handling
autocmd('BufReadPre', {
  pattern = '*',
  callback = function()
    if vim.fn.getfsize(vim.fn.expand '<afile>') > 1024 * 1024 * 10 then
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undofile = false
    end
  end,
})

-- Media Handlers
autocmd('BufReadCmd', {
  pattern = '*.pdf',
  callback = function()
    vim.fn.jobstart({ 'evince', vim.fn.expand '<afile>' }, { detach = true })
    vim.cmd 'bdelete!'
  end,
})

autocmd('BufReadCmd', {
  pattern = { '*.png', '*.jpg', '*.jpeg', '*.webp', '*.gif', '*.bmp', '*.tiff' },
  callback = function()
    vim.fn.jobstart({ 'geeqie', vim.fn.expand '<afile>' }, { detach = true })
    vim.cmd 'bdelete!'
  end,
})

autocmd('BufReadCmd', {
  pattern = { '*.mp4', '*.mkv', '*.avi', '*.mov', '*.webm', '*.flv', '*.wmv', '*.m4v' },
  callback = function()
    vim.fn.jobstart({ 'mpv', vim.fn.expand '<afile>' }, { detach = true })
    vim.cmd 'bdelete!'
  end,
})

autocmd('BufReadCmd', {
  pattern = { '*.mp3', '*.flac', '*.wav', '*.ogg', '*.m4a', '*.aac', '*.opus' },
  callback = function()
    vim.fn.jobstart({ 'mpv', '--no-video', vim.fn.expand '<afile>' }, { detach = true })
    vim.cmd 'bdelete!'
  end,
})

-- Close certain filetypes (like help, qf, LSP info) with just 'q'
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'lspinfo', 'qf', 'checkhealth', 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
  end,
})
