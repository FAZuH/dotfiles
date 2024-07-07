return {
	"gen740/SmoothCursor.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("smoothcursor").setup({})
	end,
}
