return {
  'echasnovski/mini.starter',
  version = false,
  config = function()
    local starter = require 'mini.starter'

    starter.setup {
      header = [[
███╗   ███╗ ██╗   ██╗ ███╗   ███╗ ██╗   ██╗
████╗ ████║ ██║   ██║ ████╗ ████║ ██║   ██║
██╔████╔██║ ██║   ██║ ██╔████╔██║ ██║   ██║
██║╚██╔╝██║ ██║   ██║ ██║╚██╔╝██║ ██║   ██║
██║ ╚═╝ ██║ ╚██████╔╝ ██║ ╚═╝ ██║ ╚██████╔╝
╚═╝     ╚═╝  ╚═════╝  ╚═╝     ╚═╝  ╚═════╝
        ]],

      items = {
        starter.sections.builtin_actions(),
        { name = 'Find Files', action = 'Telescope find_files', section = 'Telescope' },
        { name = 'Find text', action = 'Telescope live_grep', section = 'Telescope' },
        { name = 'Recent Files', action = 'Telescope oldfiles', section = 'Telescope' },
        { name = 'Projects', action = 'Telescope projects', section = 'Telescope' },
        { name = 'Neotree', action = 'Neotree', section = 'Others' },
        { name = 'Git', action = 'LazyGit', section = 'Others' },
        { name = 'Lazy', action = 'Lazy', section = 'Plugins' },
        { name = 'Lazy Health', action = 'Lazy health', section = 'Plugins' },
        { name = 'Lazy Profile', action = 'Lazy profile', section = 'Plugins' },
        { name = 'Lazy Update', action = 'Lazy update', section = 'Plugins' },
        { name = 'Lazy Clean', action = 'Lazy clean', section = 'Plugins' },
      },

      footer = '  I use Neovim btw',

      content_hooks = {
        starter.gen_hook.aligning('center', 'center'),
        -- starter.gen_hook.padding(10, 0),
        starter.gen_hook.adding_bullet(),
      },
    }
  end,
}
