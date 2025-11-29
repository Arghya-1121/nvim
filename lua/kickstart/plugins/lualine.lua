local lualine_stats = { stats = '' }

function lualine_stats.update_stats()
  local buf_lines = vim.api.nvim_buf_line_count(0)
  local file_size = vim.fn.getfsize(vim.fn.expand '%')
  local todo_count = 0
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match 'TODO' or line:match 'FIXME' or line:match 'HACK' or line:match 'NOTE' or line:match 'WARN' then
      todo_count = todo_count + 1
    end
  end
  local size_str = ''
  if file_size > 1024 * 1024 then
    size_str = string.format('%.1fMB', file_size / (1024 * 1024))
  elseif file_size > 1024 then
    size_str = string.format('%.1fKB', file_size / 1024)
  else
    size_str = file_size .. 'B'
  end

  local stats = '📄' .. buf_lines
  if file_size > 0 then
    stats = stats .. ' 💾' .. size_str
  end
  if todo_count > 0 then
    stats = stats .. ' 📝' .. todo_count
  end
  lualine_stats.stats = stats
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  callback = function()
    lualine_stats.update_stats()
  end,
})

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    init = function()
      if vim.fn.argc(-1) > 0 then
        --set an enpty statusline till lualine loades
        vim.o.statusline = ''
      else
        --hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      return {
        options = {
          icons_enabled = true,
          theme = 'auto',
          disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' },
            winbar = {},
          },
          ignore_focus = { 'neo-tree' },
          always_divide_middle = true,
          globalstatus = true,
          -- refresh = {
          --   statusline = 1000,
          --   tabline = 1000,
          --   winbar = 1000,
          -- },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { 'branch', color = { bg = '#2c323c' } } },
          lualine_c = {
            { 'diff' },
            { 'diagnostics', update_in_insert = true },
            { 'filetype', icon_only = true },
            { 'filename', path = 1, separator = '' },
            { 'modified', separator = '' },
          },
          lualine_x = {
            function()
              local count = #vim.fn.getbufinfo { buflisted = 1 }
              return '📂' .. count
            end,
            { 'encoding' },
            {
              'lsp_status',
              icon = '',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
                separator = ' ',
              },
              -- List of LSP names to ignore (e.g., `null-ls`):
              ignore_lsp = { 'copilot' },
              show_name = true,
            },
          },
          lualine_y = {
            { 'progress', color = { bg = '#2c323c' } },
            { 'location', color = { bg = '#2c323c' } },
          },
          lualine_z = {
            {
              function()
                return lualine_stats.stats
              end,
              color = { bg = '#0a101a' },
            },
          },
        },
      }
    end,
  },
}
