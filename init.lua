-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.o.directory = "/tmp/"
vim.o.undodir = "/tmp/"
vim.o.backupdir = "/tmp/"
vim.env.XDG_CACHE_HOME = "/tmp"
