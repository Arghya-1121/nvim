return {
  'goolord/alpha-nvim',
  priority = 2000,
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    local custom_icons = {
      new_file = '',
      files = '',
      repo = '',
      restore = '',
      close = '',
      text = '',
    }
    local function get_header(_, _)
      return {
        '███╗   ███╗██╗   ██╗███╗   ███╗██╗   ██╗',
        '████╗ ████║██║   ██║████╗ ████║██║   ██║',
        '██╔████╔██║██║   ██║██╔████╔██║██║   ██║',
        '██║╚██╔╝██║██║   ██║██║╚██╔╝██║██║   ██║',
        '██║ ╚═╝ ██║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝',
        '╚═╝     ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝',
        '          I use NeoVim btw',
        '',
        '',
      }
    end
    local datetime = tonumber(os.date ' %H ')
    local stats = require('lazy').stats()
    local total_plugins = stats.count

    local function button(sc, txt, keybind, keybind_opts)
      local b = dashboard.button(sc, txt, keybind, keybind_opts)
      b.opts.hl_shortcut = 'Number'
      return b
    end

    -- Call the local get_header function
    dashboard.section.header.val = get_header(0, true)

    dashboard.section.buttons.val = {
      -- Replaced icons.ui.new_file with custom_icons.new_file
      button('e', custom_icons.new_file .. ' New file', ':ene <BAR> startinsert <CR>'),
      -- Replaced icons.ui.files with custom_icons.files
      button('f', custom_icons.files .. ' Find Files', ':Telescope find_files <CR>'),
      -- Replaced icons.git.repo with custom_icons.repo
      button('p', custom_icons.repo .. ' Find project', "<cmd>lua require('telescope').extensions.projects.projects()<cr>"),
      -- Replaced icons.ui.restore with custom_icons.restore
      button('o', custom_icons.restore .. ' Recent Files', '<cmd>Telescope oldfiles<cr>'),
      -- Replaced icons.kinds.nvchad.Text with custom_icons.text
      button('t', custom_icons.text .. ' Find text', ':Telescope live_grep <CR>'),
      -- ' ' is a standard icon, kept as is.
      button('c', ' ' .. ' Neovim config', '<cmd>e ~/.config/nvim/ | cd %:p:h<cr>'),
      button('l', '󰒲 Lazy', '<cmd>Lazy<cr>'),
      -- Replaced icons.ui.close with custom_icons.close
      button('q', custom_icons.close .. ' Quit NVIM', ':qa<CR>'),
    }

    -- Footer logic (kept the same, relying on standard Lua/Vim functions)
    local function footer()
      local footer_datetime = os.date '  %m-%d-%Y   %H:%M:%S'
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
      -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100) -- ms variable is unused
      local value = footer_datetime .. '   Plugins ' .. total_plugins .. nvim_version_info
      return value
    end

    -- Padding logic (kept the same, but simplified the unnecessary print statement)
    local count = 0
    for _ in pairs(dashboard.section.header.val) do
      count = count + 1
    end
    local extraline = count - 14

    for _ = 1, extraline do
      table.insert(dashboard.section.header.val, 1, '')
    end

    dashboard.section.footer.val = footer()

    local greeting = function()
      local mesg
      local username = os.getenv 'USERNAME' or os.getenv 'USER' or 'Developer'
      if datetime >= 0 and datetime < 6 then
        mesg = 'Dreaming..󰒲 󰒲 '
      elseif datetime >= 6 and datetime < 12 then
        mesg = '🌅 Hi ' .. username .. ', Good Morning ☀️'
      elseif datetime >= 12 and datetime < 18 then
        mesg = '🌞 Hi ' .. username .. ', Good Afternoon ☕️'
      elseif datetime >= 18 and datetime < 21 then
        mesg = '🌆 Hi ' .. username .. ', Good Evening 🌙'
      else
        mesg = 'Hi ' .. username .. ", it's getting late, get some sleep 😴"
      end
      return mesg
    end

    local function capture(cmd, raw)
      local f = assert(io.popen(cmd, 'r'))
      local s = assert(f:read '*a')
      f:close()
      if raw then
        return s
      end
      s = string.gsub(s, '^%s+', '')
      s = string.gsub(s, '%s+$', '')
      s = string.gsub(s, '[\n\r]+', ' ')
      return s
    end

    local function split(source, sep)
      local result, i = {}, 1
      while true do
        local a, b = source:find(sep)
        if not a then
          break
        end
        local candidat = source:sub(1, a - 1)
        if candidat ~= '' then
          result[i] = candidat
        end
        i = i + 1
        source = source:sub(b + 1)
      end
      if source ~= '' then
        result[i] = source
      end
      return result
    end

    local bottom_section = {
      type = 'text',
      val = greeting,
      opts = {
        position = 'center',
      },
    }

    local section = {
      header = dashboard.section.header,
      bottom_section = bottom_section,
      buttons = dashboard.section.buttons,
      footer = dashboard.section.footer,
    }

    local opts = {
      layout = {
        { type = 'padding', val = 15 },
        section.header,
        section.buttons,
        { type = 'padding', val = 1 },
        section.bottom_section,
        { type = 'padding', val = 1 },
        section.footer,
      },
    }
    dashboard.opts.opts.noautocmd = true

    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    alpha.setup(opts)

    -- don't show status line in alpha dashboard
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = { 'AlphaReady' },
      callback = function()
        vim.cmd [[ set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3 ]]
      end,
    })

    dashboard.section.footer.opts.hl = 'Type'
    dashboard.section.header.opts.hl = 'Include'
    dashboard.section.buttons.opts.hl = 'Keyword'
  end,
}
