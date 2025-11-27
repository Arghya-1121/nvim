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
      local function get_lsp_name()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        for _, client in ipairs(clients) do
          if client.name ~= 'copilot' then
            return client.name
          end
        end
        return 'No LSP'
      end

      return {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' },
            winbar = {},
          },
          ignore_focus = {},
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
          lualine_b = {
            { 'branch', color = { bg = '#2c323c' } },
          },
          lualine_c = {
            'diff',
            'diagnostics',
            { 'filetype', icon_only = true },
            { 'filename', path = 1, separator = '' },
            { 'modified', separator = '' },
          },
          lualine_x = {

            function()
              local count = #vim.fn.getbufinfo { buflisted = 1 }
              return '📂' .. count
            end,

            get_lsp_name,
            'encoding',
          },
          lualine_y = {
            { 'progress', color = { bg = '#2c323c' } },
            { 'location', color = { bg = '#2c323c' } },
          },
          lualine_z = {
            {
              function()
                local buf_lines = vim.api.nvim_buf_line_count(0)
                local file_size = vim.fn.getfsize(vim.fn.expand '%')

                -- Count TODOs/FIXMEs in current buffer
                local todo_count = 0
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                for _, line in ipairs(lines) do
                  if line:match 'TODO' or line:match 'FIXME' or line:match 'HACK' or line:match 'NOTE' then
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

                return stats
              end,
              color = { bg = '#0a101a' },
            },
          },
        },
        -- inactive_sections = {
        --   lualine_a = {},
        --   lualine_b = {},
        --   lualine_c = { 'filename' },
        --   lualine_x = { 'location' },
        --   lualine_y = {},
        --   lualine_z = {},
        -- },
        -- tabline = {},
        -- winbar = {
        --   lualine_c = {
        -- {
        --   'navic',
        --   color_correction = 'dynamic',
        -- },
        -- },
        -- lualine_x = {},
        -- },
        -- inactive_winbar = {
        --   lualine_c = { { 'navic' } },
        -- },
        -- extensions = {},
      }
    end,
  },

  -- {
  --   'SmiteshP/nvim-navic',
  --   dependencies = 'neovim/nvim-lspconfig',
  --   opts = {
  --     lsp = {
  --       auto_attach = true,
  --     },
  --     highlight = true,
  --     separator = ' > ',
  --     depth_limit = 5,
  --   },
  -- },
}
