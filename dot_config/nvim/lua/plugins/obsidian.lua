return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre home/Obsidian/**.md",
    "BufNewFile home/Obsidian/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "Main",
          path = "~/Workspace/Notes",
        },
      },

      templates = {
        folder = "9 Templates",
      },

      daily_notes = {
        folder = "2 Areas/Daily Note",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily-note.md",
      },

      -- ui = { enable = false },

      attachments = {
        img_folder = "9 Assets",
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
        confirm_img_paste = true,
      },
    })
  end,
}
