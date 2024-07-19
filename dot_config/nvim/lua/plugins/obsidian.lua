return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre home/faz/Documents/FAZuH/**.md",
    "BufNewFile home/faz/Documents/FAZuH/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/Obsidian/FAZuH",
        },
      },

      templates = {
        folder = "99 Templates",
      },
      daily_notes = {
        folder = "2 Areas/Daily Note",
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily-note.md",
      },
    })
  end,
}
