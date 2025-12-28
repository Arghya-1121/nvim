return {
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod' },
    dependencies = {
      'ray-x/guihua.lua',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
  },
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<F9>',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Breakpoint',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into',
      },
    },
    dependencies = {
      {
        'leoluz/nvim-dap-go',
        ft = 'go',
        config = function()
          require('dap-go').setup()
        end,
      },
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          require('dapui').setup()
        end,
      },
    },
  },
}
