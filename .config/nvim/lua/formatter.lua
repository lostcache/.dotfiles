vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype

		-- -- Try LSP formatting first
		-- if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
		--     vim.lsp.buf.format({ async = false })
		--     return
		-- end

		-- Otherwise use external formatters
		local filename = vim.api.nvim_buf_get_name(0)
		local format_cmd

		if filetype == "python" then
			-- black needs --stdin-filename to find pyproject.toml
			format_cmd = "black -q --stdin-filename " .. vim.fn.shellescape(filename) .. " -"
		elseif filetype == "cpp" or filetype == "c" then
			-- clang-format needs --assume-filename to find .clang-format
			format_cmd = "clang-format --assume-filename=" .. vim.fn.shellescape(filename)
		elseif filetype == "rust" then
			-- rustfmt automatically searches for rustfmt.toml in parent directories
			format_cmd = "rustfmt"
		elseif filetype == "lua" then
			-- stylua needs --stdin-filepath to find stylua.toml
			format_cmd = "stylua --stdin-filepath " .. vim.fn.shellescape(filename) .. " -"
		elseif filetype == "zig" then
			-- zig fmt has no configuration support (opinionated formatter)
			format_cmd = "zig fmt --stdin"
		elseif filetype == "tex" or filetype == "latex" then
			-- tex-fmt looks for tex-fmt.toml in CWD or git root automatically
			format_cmd = "tex-fmt --stdin --tabsize 4 2>/dev/null"
		elseif filetype == "go" then
			format_cmd = "gofmt"
		else
			return
		end

		-- Get current buffer content
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local input = table.concat(lines, "\n")

		-- Run formatter
		local output = vim.fn.system(format_cmd, input)
		if vim.v.shell_error == 0 then
			-- Remove trailing newline to prevent extra empty line
			if output:sub(-1) == "\n" then
				output = output:sub(1, -2)
			end
			-- Replace buffer content with formatted output
			local formatted_lines = vim.split(output, "\n")
			vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
		end
	end,
})

