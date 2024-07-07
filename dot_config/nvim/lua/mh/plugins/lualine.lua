return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	priority = 500,
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight",
			},
		})
	end,
}
