return {
  "danymat/neogen",
  lazy = false,
  init = function()
    require("neogen").setup({
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    })
  end,
}
