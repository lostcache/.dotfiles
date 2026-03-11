return {
	-- Import plugin configurations
	{ import = "plugins.mini" },
	{ import = "plugins.telescope" },
	{ import = "plugins.auto-session" },
	{ import = "plugins.indent-blankline" },
	{ import = "plugins.toggleterm" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.trouble" },
	{ import = "plugins.spectre" },
	{ import = "plugins.transparent" },

	-- Load LSP and completion from separate files
	{ import = "plugins.lsp" },
	{ import = "plugins.copilot" },
}
