return {
  'andweeb/presence.nvim',
  event = 'VeryLazy',
  config = function()
    require('presence').setup {
      auto_update = true,
      neovim_image_text = 'The One True Text Editor',
      main_image = 'neovim',
      enable_line_number = false,
      show_time = false,
      editing_text = 'Editing some file',
      file_explorer_text = 'Browsing some file',
      git_commit_text = 'Committing changes',
      plugin_manager_text = 'Managing plugins',
      reading_text = 'Reading some file',
      workspace_text = 'Working on some project',
      line_number_text = 'I dont wanna tell you',
    }
  end,
}
