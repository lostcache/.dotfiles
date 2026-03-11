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

-- Custom Commands
vim.api.nvim_create_user_command("BD", function()
	local cur_buf = vim.api.nvim_get_current_buf()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == cur_buf then
			local ok = pcall(vim.api.nvim_set_current_win, win)
			if ok then
				if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
					vim.cmd("bnext")
				else
					vim.cmd("enew")
				end
			end
		end
	end
	vim.cmd("bdelete " .. cur_buf)
end, { desc = "Delete buffer but keep windows" })
