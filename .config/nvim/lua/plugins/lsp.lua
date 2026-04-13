return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- LSP keymaps setup
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local opts = { buffer = bufnr, silent = true }
					local map = vim.keymap.set

					-- LSP keymaps
					map("n", "gd", vim.lsp.buf.definition, opts)
					map("n", "K", vim.lsp.buf.hover, opts)
					map("n", "<leader>rn", vim.lsp.buf.rename, opts)
					map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					-- Set omnifunc for completion
					vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
				end,
			})

			-- Define server configurations
			local servers = {
				clangd = {
					cmd = { "clangd", "--background-index" },
				},
				zls = {
					filetypes = { "zig", "zir", "zon" },
					root_markers = { "zls.json", "build.zig", ".git" },
				},
				pyright = {},
				rust_analyzer = {},
				ocamllsp = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				svelte = {},
				go = {
					cmd = { "gopls" },
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
						},
					},
				},
			}

			-- Configure and enable servers
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
					severity = { min = vim.diagnostic.severity.HINT },
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
}
