local M = {}

M.formatters = {
	python = "black",
	cpp = "clang-format",
	c = "clang-format",
	rust = "rustfmt",
	lua = "stylua",
	zig = "zig fmt",
	tex = "tex-fmt",
	latex = "tex-fmt",
	go = "gofmt",
	markdown = "prettier",
	json = "prettier",
	yaml = "prettier",
}

function M.get_formatter(filetype)
	return M.formatters[filetype]
end

return M
