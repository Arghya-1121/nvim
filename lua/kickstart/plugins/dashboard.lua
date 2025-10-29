return {
  'goolord/alpha-nvim',
  priority = 2000,
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    vim.api.nvim_set_hl(0, 'HeaderRed', { fg = '#ff5a5a' })
    vim.api.nvim_set_hl(0, 'HeaderOrange', { fg = '#ff9a3c' })
    vim.api.nvim_set_hl(0, 'HeaderYellow', { fg = '#ffd75a' })
    vim.api.nvim_set_hl(0, 'HeaderGreen', { fg = '#5aff5a' })
    vim.api.nvim_set_hl(0, 'HeaderCyan', { fg = '#5affff' })
    vim.api.nvim_set_hl(0, 'HeaderMagenta', { fg = '#ff5aff' })
    vim.api.nvim_set_hl(0, 'Text', { fg = '#ffffff' })

    -- Build a custom layout instead of dashboard.section.header
    local colorful_header = {
      type = 'group',
      val = {
        {
          type = 'text',
          val = '███╗   ███╗██╗   ██╗███╗   ███╗██╗   ██╗',
          opts = { hl = 'HeaderRed', position = 'center' },
        },
        {
          type = 'text',
          val = '████╗ ████║██║   ██║████╗ ████║██║   ██║',
          opts = { hl = 'HeaderOrange', position = 'center' },
        },
        {
          type = 'text',
          val = '██╔████╔██║██║   ██║██╔████╔██║██║   ██║',
          opts = { hl = 'HeaderYellow', position = 'center' },
        },
        {
          type = 'text',
          val = '██║╚██╔╝██║██║   ██║██║╚██╔╝██║██║   ██║',
          opts = { hl = 'HeaderGreen', position = 'center' },
        },
        {
          type = 'text',
          val = '██║ ╚═╝ ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝',
          opts = { hl = 'HeaderCyan', position = 'center' },
        },
        {
          type = 'text',
          val = '╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ',
          opts = { hl = 'HeaderMagenta', position = 'center' },
        },
        { type = 'text', val = '↬I use NeoVim btw↫', opts = { hl = 'Text', position = 'center' } },
      },
    }

    -- 🔧 Custom icons
    local custom_icons = {
      new_file = '',
      files = '',
      repo = '',
      restore = '',
      close = '',
      text = '',
    }

    local datetime = tonumber(os.date ' %H ')
    local stats = require('lazy').stats()
    local total_plugins = stats.count

    -- 🧭 Dashboard buttons
    local function button(sc, txt, keybind, keybind_opts)
      local b = dashboard.button(sc, txt, keybind, keybind_opts)
      b.opts.hl_shortcut = 'Number'
      return b
    end

    dashboard.section.buttons.val = {
      button('e', custom_icons.new_file .. ' New file', ':ene <BAR> startinsert <CR>'),
      button('f', custom_icons.files .. ' Find Files', ':Telescope find_files <CR>'),
      button('p', custom_icons.repo .. ' Find project', "<cmd>lua require('telescope').extensions.projects.projects()<cr>"),
      button('o', custom_icons.restore .. ' Recent Files', '<cmd>Telescope oldfiles<cr>'),
      button('t', custom_icons.text .. ' Find text', ':Telescope live_grep <CR>'),
      button('c', ' ' .. ' Neovim config', '<cmd>e ~/.config/nvim/ | cd %:p:h<cr>'),
      button('l', '󰒲 Lazy', '<cmd>Lazy<cr>'),
      button('q', custom_icons.close .. ' Quit NVIM', ':qa<CR>'),
    }

    -- 🕓 Footer and Greeting
    local function footer()
      local footer_datetime = os.date '  %m-%d-%Y   %H:%M:%S'
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
      local value = footer_datetime .. '   Plugins ' .. total_plugins .. nvim_version_info
      return value
    end

    local function greeting()
      local username = os.getenv 'USERNAME' or os.getenv 'USER' or 'Developer'
      if datetime >= 0 and datetime < 6 then
        return 'Dreaming..󰒲 󰒲 '
      elseif datetime >= 6 and datetime < 12 then
        return '🌅 Hi ' .. username .. ', Good Morning ☀️'
      elseif datetime >= 12 and datetime < 18 then
        return '🌞 Hi ' .. username .. ', Good Afternoon ☕️'
      elseif datetime >= 18 and datetime < 21 then
        return '🌆 Hi ' .. username .. ', Good Evening 🌙'
      else
        return 'Hi ' .. username .. ', it’s getting late, get some sleep 😴'
      end
    end

    local bottom_section = {
      type = 'text',
      val = greeting,
      opts = { position = 'center' },
    }

    local footer_section = {
      type = 'text',
      val = footer(),
      opts = { position = 'center', hl = 'Type' },
    }

    -- 🧩 Final layout
    local opts = {
      layout = {
        { type = 'padding', val = 12 },
        colorful_header,
        { type = 'padding', val = 3 },
        dashboard.section.buttons,
        { type = 'padding', val = 1 },
        bottom_section,
        { type = 'padding', val = 1 },
        footer_section,
      },
    }

    alpha.setup(opts)

    -- 🪄 Hide status line while in dashboard
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AlphaReady',
      callback = function()
        vim.cmd [[ set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3 ]]
      end,
    })

    -- Button highlights
    dashboard.section.buttons.opts.hl = 'Keyword'
  end,
}
