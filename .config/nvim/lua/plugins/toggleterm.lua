return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				persist_size = true,
				size = 100,
				-- direction = "tab",
				shell = vim.o.shell,
				float_opts = {
					border = "rounded",
					width = function()
						return math.floor(vim.o.columns * 0.95)
					end,
					height = function()
						return math.floor(vim.o.lines * 0.95)
					end,
				},
			})
		end,
	},
}
