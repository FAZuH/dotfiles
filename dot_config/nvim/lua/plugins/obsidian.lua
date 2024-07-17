return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre home/faz/Documents/fazjournal/**.md",
    "BufNewFile home/faz/Documents/fazjournal/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/fazjournal",
      },
    },
  },
}
