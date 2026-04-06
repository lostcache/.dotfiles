-- Add gvm Go paths so gopls and go are findable
local gvm_go = "/home/lostcache/.gvm/gos/go1.26.1/bin"
local gvm_pkgs = "/home/lostcache/.gvm/pkgsets/go1.26.1/global/bin"
vim.env.PATH = gvm_go .. ":" .. gvm_pkgs .. ":" .. vim.env.PATH
vim.env.GOROOT = "/home/lostcache/.gvm/gos/go1.26.1"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require("options")
require("keymaps")
require("autocmds")
require("formatter")

-- Load plugins
require("lazy").setup("plugins", {
	change_detection = { notify = false },
})

vim.cmd.colorscheme("vague")
