return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")

			-- Install parsers
			ts.install({
				"go",
				"cpp",
				"c",
				"python",
				"rust",
				"zig",
				"ocaml",
				"lua",
				"markdown",
				"markdown_inline",
			})
		end,
	},
}

