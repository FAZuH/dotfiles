return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/neotest",
    "nvim-neotest/neotest-python",
  },
  setup = function()
    require("dapui").setup({})

    vim.builtin.dap.active = true
    local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
    pcall(function()
      require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
    end)

    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = {
            justMyCode = false,
            console = "integratedTerminal",
          },
          args = { "--log-level", "DEBUG", "--quiet" },
          runner = "pytest",
        }),
      },
    })
  end,
}
