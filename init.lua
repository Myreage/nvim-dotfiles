-- Basic settings
vim.o.number = true
vim.o.cursorline = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	spec = {
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("tokyonight")
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {},
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
			opts = {
				ensure_installed = { "lua", "javascript", "typescript", "css", "json" },
				auto_install = true,
				highlight = {
					enable = true,
				},
			},
		},
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
				},
			},
			init = function()
				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = "*",
					callback = function(args)
						require("conform").format({ bufnr = args.buf })
					end,
				})
			end,
		},

		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{ -- optional blink completion source for require statements and module annotations
			"saghen/blink.cmp",
			version = "1.*",
			opts = {
				sources = {
					-- add lazydev to your completion providers
					default = { "lazydev", "lsp", "path", "snippets", "buffer" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
					},
				},
				completion = { documentation = { auto_show = true } },
				signature = { enabled = true },
				fuzzy = { implementation = "prefer_rust" },
			},
		},
	},
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
