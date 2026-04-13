return {
	{
		"echasnovski/mini.icons",
		opts = {},
		lazy = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

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
			local statusline = require("mini.statusline")
			statusline.setup({
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ truncate_width = 120 })
						local git = statusline.section_git({ truncate_width = 40 })
						local diagnostics = statusline.section_diagnostics({ truncate_width = 75 })
						local filename = statusline.section_filename({ truncate_width = 140 })
						local location = statusline.section_location({ truncate_width = 75 })
						local search = statusline.section_searchcount({ truncate_width = 75 })

						-- LSP and Formatter info
						local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
						local lsp_names = {}
						for _, client in ipairs(lsp_clients) do
							table.insert(lsp_names, client.name)
						end
						local lsp_status = #lsp_names > 0 and table.concat(lsp_names, ", ") or "No LSP"

						local formatter_config = require("formatter_config")
						local formatter = formatter_config.get_formatter(vim.bo.filetype) or "None"
						local lsp_fmt = string.format("LSP: %s | FM: %s", lsp_status, formatter)

						-- Custom diff summary
						local diff_stats = vim.b.minidiff_summary or vim.g.minidiff_summary
						local diff_add = (diff_stats and (diff_stats.add or 0) > 0) and ("+" .. diff_stats.add) or ""
						local diff_change = (diff_stats and (diff_stats.change or 0) > 0) and ("~" .. diff_stats.change)
							or ""
						local diff_delete = (diff_stats and (diff_stats.delete or 0) > 0) and ("-" .. diff_stats.delete)
							or ""

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							{ hl = "MiniStatuslineFilename", strings = { "%=" } },
							{ hl = "MiniStatuslineDevinfo", strings = { git } },
							{ hl = "MiniStatuslineFilename", strings = { "%=" } },
							{ hl = "MiniStatuslineDiffAdd", strings = { diff_add } },
							{ hl = "MiniStatuslineDiffChange", strings = { diff_change } },
							{ hl = "MiniStatuslineDiffDelete", strings = { diff_delete } },
							{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
							{ hl = "MiniStatuslineFileinfo", strings = { lsp_fmt } },
							{ hl = mode_hl, strings = { location, search } },
						})
					end,
				},
			})

			-- Remove backgrounds and just use font colors
			local function patch_colors()
				local groups = {
					"MiniStatuslineModeNormal",
					"MiniStatuslineModeInsert",
					"MiniStatuslineModeVisual",
					"MiniStatuslineModeReplace",
					"MiniStatuslineModeCommand",
					"MiniStatuslineModeOther",
					"MiniStatuslineDevinfo",
					"MiniStatuslineFileinfo",
					"MiniStatuslineFilename",
				}

				for _, group in ipairs(groups) do
					local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
					-- Use background as foreground for modes to keep the identifying color
					local fg = (group:find("Mode") and hl.bg) or hl.fg
					vim.api.nvim_set_hl(0, group, { fg = fg, bg = "NONE", reverse = false })
				end

				-- Custom diff colors
				vim.api.nvim_set_hl(0, "MiniStatuslineDiffAdd", { fg = "#10B981", bg = "NONE" })
				vim.api.nvim_set_hl(0, "MiniStatuslineDiffChange", { fg = "#F59E0B", bg = "NONE" })
				vim.api.nvim_set_hl(0, "MiniStatuslineDiffDelete", { fg = "#EF4444", bg = "NONE" })

				-- Ensure the main statusline bar itself is transparent
				vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
				vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
			end

			patch_colors()
			-- Re-apply on colorscheme change
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = patch_colors,
			})
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
