return {
  "simrat39/rust-tools.nvim",
  ft = { "rust" },
  opts = function()
    return require("lazyvim.util").opts("nvim-lspconfig").servers.rust_analyzer or {}
  end,
}
