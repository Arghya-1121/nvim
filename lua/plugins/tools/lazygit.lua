return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
      { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current File' },
      { '<leader>gl', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit Log' },
      { '<leader>gc', '<cmd>LazyGitConfig<cr>', desc = 'LazyGit Config' },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
      vim.g.lazygit_use_custom_config_file_path = 0
    end,
  },

  -- Diffview for advanced diff viewing
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff (Diffview)' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'Git File History (All)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git File History (Current)' },
      { '<leader>gm', '<cmd>DiffviewOpen main<cr>', desc = 'Diff with main' },
      { '<leader>gM', '<cmd>DiffviewOpen HEAD~1<cr>', desc = 'Diff with previous commit' },
      { '<leader>gv', '<cmd>DiffviewToggleFiles<cr>', desc = 'Toggle Diffview Files' },
    },
    config = function()
      local actions = require 'diffview.actions'

      require('diffview').setup {
        diff_binaries = false,
        enhanced_diff_hl = true,
        git_cmd = { 'git' },
        hg_cmd = { 'hg' },
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
          done = '✓',
        },
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
          win_config = {
            position = 'bottom',
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = { 80 }
          end,
          view_opened = function(view)
            print(('A new %s was opened!'):format(view.class:name()))
          end,
        },
        keymaps = {
          disable_defaults = false,
          view = {
            { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' } },
            { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
            { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
            { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
            { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel.' } },
            { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle through available layouts.' } },
            { 'n', '[x', actions.prev_conflict, { desc = 'In the merge-tool: jump to the previous conflict' } },
            { 'n', ']x', actions.next_conflict, { desc = 'In the merge-tool: jump to the next conflict' } },
            { 'n', '<leader>co', actions.conflict_choose 'ours', { desc = 'Choose the OURS version of a conflict' } },
            { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Choose the THEIRS version of a conflict' } },
            { 'n', '<leader>cb', actions.conflict_choose 'base', { desc = 'Choose the BASE version of a conflict' } },
            { 'n', '<leader>ca', actions.conflict_choose 'all', { desc = 'Choose all the versions of a conflict' } },
            { 'n', 'dx', actions.conflict_choose 'none', { desc = 'Delete the conflict region' } },
            { 'n', '<leader>cO', actions.conflict_choose_all 'ours', { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>cT', actions.conflict_choose_all 'theirs', { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>cB', actions.conflict_choose_all 'base', { desc = 'Choose the BASE version of a conflict for the whole file' } },
            { 'n', '<leader>cA', actions.conflict_choose_all 'all', { desc = 'Choose all the versions of a conflict for the whole file' } },
            { 'n', 'dX', actions.conflict_choose_all 'none', { desc = 'Delete the conflict region for the whole file' } },
          },
          diff1 = {
            { 'n', 'g?', actions.help { 'view', 'diff1' }, { desc = 'Open the help panel' } },
          },
          diff2 = {
            { 'n', 'g?', actions.help { 'view', 'diff2' }, { desc = 'Open the help panel' } },
          },
          diff3 = {
            { 'n', 'g?', actions.help { 'view', 'diff3' }, { desc = 'Open the help panel' } },
          },
          diff4 = {
            { 'n', 'g?', actions.help { 'view', 'diff4' }, { desc = 'Open the help panel' } },
          },
          file_panel = {
            { 'n', 'j', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
            { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
            { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
            { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
            { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
            { 'n', 'l', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
            { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
            { 'n', '-', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry' } },
            { 'n', 'S', actions.stage_all, { desc = 'Stage all entries' } },
            { 'n', 'U', actions.unstage_all, { desc = 'Unstage all entries' } },
            { 'n', 'X', actions.restore_entry, { desc = 'Restore entry to the state on the left side' } },
            { 'n', 'L', actions.open_commit_log, { desc = 'Open the commit log panel' } },
            { 'n', 'zo', actions.open_fold, { desc = 'Expand fold' } },
            { 'n', 'h', actions.close_fold, { desc = 'Collapse fold' } },
            { 'n', 'zc', actions.close_fold, { desc = 'Collapse fold' } },
            { 'n', 'za', actions.toggle_fold, { desc = 'Toggle fold' } },
            { 'n', 'zR', actions.open_all_folds, { desc = 'Expand all folds' } },
            { 'n', 'zM', actions.close_all_folds, { desc = 'Collapse all folds' } },
            { 'n', '<c-b>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' } },
            { 'n', '<c-f>', actions.scroll_view(0.25), { desc = 'Scroll the view down' } },
            { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' } },
            { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
            { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
            { 'n', 'i', actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
            { 'n', 'f', actions.toggle_flatten_dirs, { desc = 'Flatten empty subdirectories in tree listing style' } },
            { 'n', 'R', actions.refresh_files, { desc = 'Update stats and entries in the file list' } },
            { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
            { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel' } },
            { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle available layouts' } },
            { 'n', '[x', actions.prev_conflict, { desc = 'Go to the previous conflict' } },
            { 'n', ']x', actions.next_conflict, { desc = 'Go to the next conflict' } },
            { 'n', 'g?', actions.help 'file_panel', { desc = 'Open the help panel' } },
            { 'n', '<leader>cO', actions.conflict_choose_all 'ours', { desc = 'Choose the OURS version of a conflict for the whole file' } },
            { 'n', '<leader>cT', actions.conflict_choose_all 'theirs', { desc = 'Choose the THEIRS version of a conflict for the whole file' } },
            { 'n', '<leader>cB', actions.conflict_choose_all 'base', { desc = 'Choose the BASE version of a conflict for the whole file' } },
            { 'n', '<leader>cA', actions.conflict_choose_all 'all', { desc = 'Choose all the versions of a conflict for the whole file' } },
            { 'n', 'dX', actions.conflict_choose_all 'none', { desc = 'Delete the conflict region for the whole file' } },
          },
          file_history_panel = {
            { 'n', 'g!', actions.options, { desc = 'Open the option panel' } },
            { 'n', '<C-A-d>', actions.open_in_diffview, { desc = 'Open the entry under the cursor in a diffview' } },
            { 'n', 'y', actions.copy_hash, { desc = 'Copy the commit hash of the entry under the cursor' } },
            { 'n', 'L', actions.open_commit_log, { desc = 'Show commit details' } },
            { 'n', 'zR', actions.open_all_folds, { desc = 'Expand all folds' } },
            { 'n', 'zM', actions.close_all_folds, { desc = 'Collapse all folds' } },
            { 'n', 'j', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
            { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry.' } },
            { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry.' } },
            { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry.' } },
            { 'n', '<c-b>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' } },
            { 'n', '<c-f>', actions.scroll_view(0.25), { desc = 'Scroll the view down' } },
            { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
            { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' } },
            { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
            { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
            { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
            { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel' } },
            { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle available layouts' } },
            { 'n', 'g?', actions.help 'file_history_panel', { desc = 'Open the help panel' } },
          },
          option_panel = {
            { 'n', '<tab>', actions.select_entry, { desc = 'Change the current option' } },
            { 'n', 'q', actions.close, { desc = 'Close the panel' } },
            { 'n', 'g?', actions.help 'option_panel', { desc = 'Open the help panel' } },
          },
          help_panel = {
            { 'n', 'q', actions.close, { desc = 'Close help menu' } },
            { 'n', '<esc>', actions.close, { desc = 'Close help menu' } },
          },
        },
      }
    end,
  },

  -- Gitsigns for inline git decorations
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)

      -- Gitsigns keymaps
      local gs = package.loaded.gitsigns

      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Next Hunk' })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = 'Previous Hunk' })

      -- Actions
      vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage Hunk' })
      vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset Hunk' })
      vim.keymap.set('v', '<leader>gs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage Hunk' })
      vim.keymap.set('v', '<leader>gr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset Hunk' })
      vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage Buffer' })
      vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
      vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset Buffer' })
      vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview Hunk' })
      vim.keymap.set('n', '<leader>gb', function()
        gs.blame_line { full = true }
      end, { desc = 'Blame Line' })
      vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { desc = 'Toggle Line Blame' })
      vim.keymap.set('n', '<leader>gD', gs.diffthis, { desc = 'Diff This' })
      vim.keymap.set('n', '<leader>gt', gs.toggle_deleted, { desc = 'Toggle Deleted' })

      -- Text object
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select Hunk' })
    end,
  },

  -- Neogit - Magit clone for Neovim
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
      { '<leader>gN', '<cmd>Neogit kind=split<cr>', desc = 'Neogit Split' },
    },
    opts = {
      use_icons = true,
      integrations = {
        telescope = true,
        diffview = true,
      },
      disable_signs = false,
      disable_hint = false,
      disable_commit_confirmation = false,
      disable_builtin_notifications = false,
      disable_insert_on_commit = false,
      signs = {
        section = { '', '' },
        item = { '', '' },
        hunk = { '', '' },
      },
    },
  },

  -- Git conflict resolver
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'BufReadPost',
    config = function()
      require('git-conflict').setup {
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
        list_opener = 'copen',
        highlights = {
          incoming = 'DiffAdd',
          current = 'DiffText',
        },
      }

      vim.keymap.set('n', '<leader>gco', '<cmd>GitConflictChooseOurs<cr>', { desc = 'Choose Ours (Current)' })
      vim.keymap.set('n', '<leader>gct', '<cmd>GitConflictChooseTheirs<cr>', { desc = 'Choose Theirs (Incoming)' })
      vim.keymap.set('n', '<leader>gcb', '<cmd>GitConflictChooseBoth<cr>', { desc = 'Choose Both' })
      vim.keymap.set('n', '<leader>gc0', '<cmd>GitConflictChooseNone<cr>', { desc = 'Choose None' })
      vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<cr>', { desc = 'Next Conflict' })
      vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<cr>', { desc = 'Previous Conflict' })
      vim.keymap.set('n', '<leader>gcl', '<cmd>GitConflictListQf<cr>', { desc = 'List Conflicts' })
    end,
  },
}
