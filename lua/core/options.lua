vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.cmdheight = 0
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 100
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = false
vim.o.scrolloff = 5
vim.o.confirm = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.smoothscroll = true
vim.opt.pumheight = 10 -- Limit completion menu height
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.lazyredraw = false -- Set to true ONLY if you see flickering -- Faster scrolling
vim.opt.termguicolors = true -- True color support
vim.opt.conceallevel = 2 -- Hide * markup for bold/italic in markdown

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Backup and Undo tree directories
vim.o.directory = '/tmp/'
vim.o.undodir = '/tmp/'
vim.o.backupdir = '/tmp/'
vim.env.XDG_CACHE_HOME = '/tmp'
vim.env.NVIM_LOG_FILE = '/tmp/nvim.log'

