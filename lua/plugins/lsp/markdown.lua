return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown', 'md' },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        left_pad = 2,
        right_pad = 2,
        width = 'block',
        border = 'thin',
        highlight = 'RenderMarkdownCode',
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
      },
      quote = {
        enabled = true,
        icon = '▋',
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        style = 'full',
        cell = 'padded',
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      -- Automatically toggle render mode and diagnostics
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
        pattern = { '*.md', '*.markdown' },
        callback = function()
          vim.cmd 'RenderMarkdown enable'
          vim.diagnostic.enable(false)
        end,
      })

      vim.api.nvim_create_autocmd('InsertEnter', {
        pattern = { '*.md', '*.markdown' },
        callback = function()
          vim.cmd 'RenderMarkdown disable'
          vim.diagnostic.enable(true)
        end,
      })

      -- Keymaps for markdown
      vim.keymap.set('n', '<leader>mt', ':RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Render' })
      vim.keymap.set('n', '<leader>me', ':RenderMarkdown enable<CR>', { desc = 'Enable Markdown Render' })
      vim.keymap.set('n', '<leader>md', ':RenderMarkdown disable<CR>', { desc = 'Disable Markdown Render' })
    end,
  },

  -- Markdown Preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_filetypes = { 'markdown' }

      -- Keymaps
      vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = 'Markdown Preview' })
      vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', { desc = 'Stop Markdown Preview' })
      vim.keymap.set('n', '<leader>mP', ':MarkdownPreviewToggle<CR>', { desc = 'Toggle Markdown Preview' })
    end,
  },

  -- Better markdown editing
  {
    'bullets-vim/bullets.vim',
    ft = { 'markdown', 'text' },
    config = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_mapping_leader = ''
      vim.g.bullets_delete_last_bullet_if_empty = 1
      vim.g.bullets_line_spacing = 1
      vim.g.bullets_pad_right = 1
      vim.g.bullets_max_alpha_characters = 2
      vim.g.bullets_nested_checkboxes = 1
      vim.g.bullets_checkbox_markers = ' .oOX'
      vim.g.bullets_renumber_on_change = 1
    end,
  },

  -- Table mode for easy table creation
  {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown' },
    config = function()
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_corner_corner = '|'
      vim.g.table_mode_header_fillchar = '-'

      -- Keymaps
      vim.keymap.set('n', '<leader>mm', ':TableModeToggle<CR>', { desc = 'Toggle Table Mode' })
      vim.keymap.set('n', '<leader>mr', ':TableModeRealign<CR>', { desc = 'Realign Table' })
    end,
  },

  -- Markdown TOC generator
  {
    'mzlogin/vim-markdown-toc',
    ft = { 'markdown' },
    config = function()
      vim.g.vmt_auto_update_on_save = 1
      vim.g.vmt_dont_insert_fence = 0
      vim.g.vmt_fence_text = 'TOC'
      vim.g.vmt_fence_closing_text = '/TOC'
      vim.g.vmt_fence_hidden_markdown_style = 'GFM'

      -- Keymaps
      vim.keymap.set('n', '<leader>mT', ':GenTocGFM<CR>', { desc = 'Generate TOC (GitHub)' })
      vim.keymap.set('n', '<leader>mu', ':UpdateToc<CR>', { desc = 'Update TOC' })
      vim.keymap.set('n', '<leader>mR', ':RemoveToc<CR>', { desc = 'Remove TOC' })
    end,
  },

  -- Peek markdown in floating window
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    ft = { 'markdown' },
    config = function()
      require('peek').setup {
        auto_load = true,
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,
        app = 'browser',
        filetype = { 'markdown' },
        throttle_at = 200000,
        throttle_time = 'auto',
      }

      vim.keymap.set('n', '<leader>mo', ':PeekOpen<CR>', { desc = 'Peek Open' })
      vim.keymap.set('n', '<leader>mc', ':PeekClose<CR>', { desc = 'Peek Close' })
    end,
  },
}

