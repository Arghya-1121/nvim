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
        local clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #clients > 0 then
          return clients[1].name
        else
          return 'No LSP'
        end
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
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            { 'filetype', icon_only = true, separator = '' },
            { 'filename', path = 1 },
            'modified',
          },
          lualine_x = { get_lsp_name, 'encoding' },
          lualine_y = { { 'progress', separator = '' }, 'location' },
          lualine_z = {
            function()
              return '  ' .. os.date '%I:%M:%S %p'
            end,
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
