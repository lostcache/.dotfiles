return {
	-- File explorer
	{
		"echasnovski/mini.files",
		config = function()
			require("mini.files").setup()

			-- overrides "/" in mini-files buffer to use default "/" search.
			-- this is needed as the default "/" is mapped to use telescope fuzzy search.
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					vim.keymap.set("n", "/", "/", { buffer = args.data.buf_id })
				end,
			})
		end,
	},

	-- Auto pairs
	{
		"echasnovski/mini.pairs",
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- Git diff signs
	{
		"echasnovski/mini.diff",
		config = function()
			require("mini.diff").setup({
				view = {
					style = "sign",
					signs = { add = "│", change = "│", delete = "│" },
				},
			})
		end,
	},

	-- Buffer removal
	{
		"echasnovski/mini.bufremove",
		config = function()
			require("mini.bufremove").setup()
		end,
	},

	-- Highlight word under cursor
	{
		"echasnovski/mini.cursorword",
		config = function()
			require("mini.cursorword").setup()
		end,
	},

	-- Highlight patterns (TODO, FIXME, etc)
	{
		"echasnovski/mini.hipatterns",
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},

	{ "echasnovski/mini.comment" },

	{ "echasnovski/mini.fuzzy", version = "*" },

	{
		"echasnovski/mini.completion",
		config = function()
			require("mini.fuzzy").setup()
			require("mini.completion").setup({
				lsp_completion = {
					process_items = require("mini.fuzzy").process_lsp_items,
				},
				completeopt = "menuone,noselect,fuzzy,nosort",
			})

			-- Automatically trigger completion on '.'
			vim.api.nvim_create_autocmd("TextChangedI", {
				pattern = "*",
				callback = function()
					if vim.fn.getline(".")[vim.fn.col(".") - 1] == "." then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
					end
				end,
			})
		end,
	},

	{
		"https://github.com/nvim-mini/mini.statusline",
		config = function()
			require("mini.statusline").setup()
		end,
	},

	{ "https://github.com/nvim-mini/mini.base16" },

	{
		"https://github.com/nvim-mini/mini.tabline",
		config = function()
			require("mini.tabline").setup()
		end,
	},

	{
		"https://github.com/nvim-mini/mini.visits",
		config = function()
			require("mini.visits").setup()
		end,
	},

	{
		"https://github.com/ribru17/bamboo.nvim",
		config = function()
			require("bamboo").setup({
				style = "multiplex",
			})
		end,
	},
}
