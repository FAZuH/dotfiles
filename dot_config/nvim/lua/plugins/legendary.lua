return {
	"mrjones2014/legendary.nvim",
	priority = 10000,
	lazy = false,

	config = function()
		local legendary = require("legendary")

		legendary.setup({})
	end,
}
