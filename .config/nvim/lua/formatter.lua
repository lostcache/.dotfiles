local formatter_config = require("formatter_config")

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		local filename = vim.api.nvim_buf_get_name(0)
		local formatter = formatter_config.get_formatter(filetype)

		if not formatter then
			return
		end

		local format_cmd
		if formatter == "black" then
			format_cmd = "black -q --stdin-filename " .. vim.fn.shellescape(filename) .. " -"
		elseif formatter == "clang-format" then
			format_cmd = "clang-format --assume-filename=" .. vim.fn.shellescape(filename)
		elseif formatter == "rustfmt" then
			format_cmd = "rustfmt --edition 2024"
		elseif formatter == "stylua" then
			format_cmd = "stylua --stdin-filepath " .. vim.fn.shellescape(filename) .. " -"
		elseif formatter == "zig fmt" then
			format_cmd = "zig fmt --stdin"
		elseif formatter == "tex-fmt" then
			format_cmd = "tex-fmt --stdin --tabsize 4 2>/dev/null"
		elseif formatter == "gofmt" then
			format_cmd = "gofmt"
		elseif formatter == "prettier" then
			format_cmd = "prettier --stdin-filepath " .. vim.fn.shellescape(filename)
		end

		if not format_cmd then
			return
		end

		-- Get current buffer content
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local input = table.concat(lines, "\n")

		-- Run formatter
		local output = vim.fn.system(format_cmd, input)
		if vim.v.shell_error == 0 then
			-- Remove trailing newline
			if output:sub(-1) == "\n" then
				output = output:sub(1, -2)
			end
			-- Replace buffer content
			local formatted_lines = vim.split(output, "\n")
			vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
		end
	end,
})
