return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()

    vim.keymap.set("n", "<F7>", function()
      require("dapui").toggle()
    end, { desc = "Toggle Neovim Debug Window" })

    vim.keymap.set("n", "<F11>", function()
      require("dap").continue()
    end, { desc = "Continue while debugging" })

    vim.keymap.set("n", "<F9>", function()
      require("dap").step_over()
    end, { desc = "Step Over while debugging" })

    vim.keymap.set("n", "<F10>", function()
      require("dap").step_into()
    end, { desc = "Step Into while debugging" })

    vim.keymap.set("n", "<F12>", function()
      require("dap").step_out()
    end, { desc = "Step Out whiel debugging" })

    vim.keymap.set("n", "<leader>db", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Toggle Breakpoint" })
  end,
}