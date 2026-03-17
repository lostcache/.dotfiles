-- Filetype specific settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "lua", "cpp", "zig", "rust" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

-- LSP highlight clear
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
