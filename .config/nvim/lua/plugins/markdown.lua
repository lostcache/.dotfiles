return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
		ft = { "markdown" },
		opts = {
			-- "Render" only in normal mode, "source" in insert mode
			render_modes = { "n", "c" },
			-- Integration with mini.icons
			file_types = { "markdown" },
			-- You can customize further icons/styles here
		},
	},
}
