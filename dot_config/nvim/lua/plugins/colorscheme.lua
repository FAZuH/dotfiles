return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({ transparent = true })

		vim.cmd("colorscheme tokyonight")
	end,
}
