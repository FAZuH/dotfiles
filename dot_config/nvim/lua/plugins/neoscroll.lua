return {
  "karb94/neoscroll.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("neoscroll").setup({})
  end,
}
