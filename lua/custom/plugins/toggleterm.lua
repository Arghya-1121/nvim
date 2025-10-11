return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
      { "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm direction=float<cr>]], mode = "t", desc = "Toggle floating terminal (from terminal)" },
      { "<C-/>", "<cmd>2ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
      { "<C-/>", [[<C-\><C-n><cmd>2ToggleTerm size=15 direction=horizontal<cr>]], mode = "t", desc = "Toggle horizontal terminal (from terminal)" },
    },
    opts = {
      open_mapping = [[<F4>]],
      direction = "float",
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
    },
  },
}