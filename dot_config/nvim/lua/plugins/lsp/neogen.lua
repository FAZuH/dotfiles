return {
  "danymat/neogen",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
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
