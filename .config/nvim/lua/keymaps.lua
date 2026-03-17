local map = vim.keymap.set

-- General
map("i", "jk", "<ESC>")

-- Telescope
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end)
map("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end)
map("n", "<leader>fw", function()
	require("telescope.builtin").live_grep()
end)
map("n", "<leader>ss", function()
	-- You can pass additional configuration to current_buffer_fuzzy_find here
	-- e.g. require('telescope.themes').get_dropdown { winblend = 10, previewer = false }
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end)

-- File explorer
map("n", "<leader>e", function()
	require("mini.files").open()
end)

-- Clipboard
map({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
map({ "n", "v", "x" }, "<leader>d", '"+d<CR>')

-- Custom commands
map("n", "<leader>rr", ":!./run.sh<CR>")
map("n", "<leader>q", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer but keep windows" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Terminal
map("n", "<leader>t", ":ToggleTerm<CR>")
map("t", "jk", "<C-\\><C-n>")

-- Clear search
map("n", "<leader>n", ":nohl<CR>")

-- Buffer navigation
map("n", "H", ":bprev<CR>")
map("n", "L", ":bnext<CR>")

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.get_next)
map("n", "]d", vim.diagnostic.get_prev)
map("n", "<leader>dl", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end)

-- Completion navigation (only applies when popup menu is visible)
-- This preserves Ctrl-i/Ctrl-o jump navigation in normal mode
vim.api.nvim_set_keymap("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true })
