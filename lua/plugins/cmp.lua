return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),

      ["<CR>"] = cmp.mapping(function(fallback)
        fallback() -- just insert a newline
      end, { "i", "s" }),
    })
  end,
}
