return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			-- v1 API (active until :Lazy update nvim-treesitter switches to master branch)
			local ok, ts = pcall(require, "nvim-treesitter")
			if ok and ts.install then
				ts.install({
					"go", "cpp", "c", "python", "rust", "zig",
					"ocaml", "lua", "markdown", "markdown_inline", "svelte",
				})
			end

			-- master branch API (active after :Lazy update nvim-treesitter)
			local ok2, configs = pcall(require, "nvim-treesitter.configs")
			if ok2 then
				configs.setup({
					ensure_installed = {
						"go", "cpp", "c", "python", "rust", "zig",
						"ocaml", "lua", "markdown", "markdown_inline", "svelte",
					},
					highlight = { enable = true },
				})
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "go", "c", "cpp", "python", "rust", "zig", "ocaml", "lua", "markdown", "svelte" },
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
