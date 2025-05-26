return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
    cmd = "ToggleTerm",
    keys = {
      { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<cr>]], mode = "t", desc = "Toggle terminal (from terminal)" },
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
