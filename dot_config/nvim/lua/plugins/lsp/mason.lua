return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function(_, opts)
    local conf = vim.tbl_deep_extend("keep", opts, {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    require("mason").setup(conf)

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "clangd",
        "bashls",
      },
    })

    local mason_tool_installer = require("mason-tool-installer")
    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "biome", -- biome formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "clang-format", -- c formatter
        "pylint",
        "eslint_d",
        -- "shellcheck", -- sh linter
      },
    })
  end,
}
