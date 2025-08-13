return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function() -- Mapping tab is already used in NvChad
      require("copilot").setup({
        suggestion = {
          enable = false,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<C-y>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-e>",
          },
        },
        panel = {
          enable = true,
          auto_refresh = true,
          auto_close = true,
          layout = {
            position = "right",
            width = 30,
          },
        },
        filetypes = {
          all = false,
          javascript = true,
          typescript = true,
          lua = true,
          html = true,
          css = true,
          markdown = true,
          -- Add more file types as needed
        },
      })
      vim.g.copilot_no_tab_map = true -- Disable tab mapping
      vim.g.copilot_assume_mapped = true -- Assume that the mapping is already done
    end,
  },
}
