return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")

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
				"svelte",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "go", "c", "cpp", "python", "rust", "zig", "ocaml", "lua", "markdown", "svelte" },
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}
