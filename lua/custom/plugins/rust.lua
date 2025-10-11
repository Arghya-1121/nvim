return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { auto_focus = true },
          inlay_hints = { only_current_line = false },
        },
        server = {
          on_attach = function(_, bufnr)
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Run project (F5)
            map("n", "<F5>", function()
              vim.cmd("!cargo run")
            end, "Cargo Run")

            -- Kill running job (F8)
            map("n", "<F8>", function()
              vim.cmd("!pkill -f cargo") -- WARNING: kills all cargo run processes
            end, "Stop Cargo Run")

            -- Rust tools
            map("n", "<leader>rr", function()
              vim.cmd("RustLsp runnables")
            end, "Runnables")
            map("n", "<leader>rh", function()
              vim.cmd("RustLsp hover actions")
            end, "Hover Actions")
          end,
        },
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
          ),
        },
      }
    end,
  },
}