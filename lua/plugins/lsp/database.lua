return {
  {
    'kristijanhusak/vim-dadbod-ui',
    event = 'VeryLazy',
    dependencies = {
      'tpope/vim-dadbod',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      vim.g.dadbod_mysql_cmd = 'mariadb'
      -- Remember previous window before toggling DBUI so new queries reuse it
      vim.keymap.set('n', '<leader>db', function()
        vim.g._dbui_prev_win = vim.api.nvim_get_current_win()
        vim.cmd 'DBUIToggle'
      end, { desc = 'Toggle DB UI' })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dbout',
        callback = function()
          vim.opt_local.foldlevel = 20
        end,
      })
      local function setup_db_completion()
        if package.loaded['cmp'] then
          local cmp = require 'cmp'
          cmp.setup.buffer {
            sources = cmp.config.sources({ { name = 'vim-dadbod-completion' } }, { { name = 'buffer' } }),
          }
        else
          vim.bo.omnifunc = 'vim_dadbod_completion#omni'
        end
      end

      local function reuse_prev_window_for_sql()
        local prev = vim.g._dbui_prev_win
        if not (prev and vim.api.nvim_win_is_valid(prev)) then
          return
        end
        local has_dbui = false
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          local b = vim.api.nvim_win_get_buf(w)
          local ft = vim.bo[b].filetype
          if ft == 'dbui' then
            has_dbui = true
            break
          end
        end
        if not has_dbui then
          return
        end
        local cur = vim.api.nvim_get_current_win()
        if cur == prev then
          return
        end
        local buf = vim.api.nvim_get_current_buf()
        pcall(vim.api.nvim_win_set_buf, prev, buf)
        pcall(vim.api.nvim_win_close, cur, true)
      end
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          vim.schedule(setup_db_completion)
          vim.schedule(reuse_prev_window_for_sql)
        end,
      })
    end,
  },
}
