return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("everforest").setup({
			-- Your config тут, якщо є додаткові налаштування
			background = "medium",
			transparent_background_level = 0,
			italics = true,
			disable_italic_comments = false,
			on_highlights = function(hl, _)
				hl["@string.special.symbol.ruby"] = { link = "@field" }
			end,
		})
		-- Активувати тему після налаштувань
		require("everforest").load()
		vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { link = "Blue" }) -- Change param after theme load
	end,
}
