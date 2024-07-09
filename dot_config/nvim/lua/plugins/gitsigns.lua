return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        require("core.keymaps").gitsigns_on_attach_callback(bufnr)
      end,
    })
  end,
}
