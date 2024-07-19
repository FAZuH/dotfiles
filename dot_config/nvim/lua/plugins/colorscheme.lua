return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        notify = true,
      },
    })

    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
-- return {
--   -- "folke/tokyonight.nvim",
--   -- priority = 1000,
--   -- config = function()
--   --   require("tokyonight").setup({ transparent = true })
--   --
--   --   vim.cmd("colorscheme tokyonight")
--   -- end,
-- }, {
