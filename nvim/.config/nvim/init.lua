-- Learn about Neovim's lua api
-- https://neovim.io/doc/user/lua-guide.html

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.signcolumn = "yes"

-- Space as the leader key
vim.g.mapleader = " "

-- ### load plugins with vim-plug
local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- NERDTree: file tree
Plug("preservim/nerdtree", { ["on"] = "NERDTreeToggle" })

-- Surround helpers
Plug("tpope/vim-surround")

-- Comment helpers
Plug("tpope/vim-commentary")

-- Git helpers
Plug("tpope/vim-fugitive")
Plug("lewis6991/gitsigns.nvim")

-- Telescope: file search
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { ["tag"] = "0.1.8" })

-- WhichKey: help with leader keys
-- https://github.com/folke/which-key.nvim
Plug("folke/which-key.nvim")

-- Formatter and Mason (manages formatters)
Plug("mhartington/formatter.nvim")
Plug("mason-org/mason.nvim")

-- Tokyo Night: colorscheme
Plug("folke/tokyonight.nvim")

-- LSP configuration
-- need v1.8 for compatibility with (Ubuntu) Neovim 0.9
Plug("neovim/nvim-lspconfig", { ["tag"] = "v1.8.0" })

-- Auto-save files
Plug("pocco81/auto-save.nvim")

vim.call("plug#end")
-- end load plugins

-- ### Setup
-- Formatter
require("mason").setup()
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		python = {
			require("formatter.filetypes.python").autopep8,
		},
		toml = {
			require("formatter.filetypes.toml").taplo,
		},
	},
})

-- LSP
-- https://github.com/neovim/nvim-lspconfig/blob/v1.8.0/doc/configs.md
local lspconfig = require("lspconfig")
lspconfig.ts_ls.setup({})
lspconfig.html.setup({ filetypes = { "html", "hbs" } })

-- Syntax highlighting
vim.filetype.add({
	extension = { hbs = "html" },
})

-- ### Keymaps
-- File Tree
vim.keymap.set("n", "<leader>e", "<cmd>NERDTreeToggle<cr>", { desc = "File tree" })

-- Telescope
require("which-key").add({ { "<leader>f", group = "Find" } })
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })

-- Formatter
require("which-key").add({ { "<leader>r", group = "Format" } })
vim.keymap.set("n", "<leader>rf", "<cmd>Format<cr>", { desc = "Format current file" })
vim.keymap.set("n", "<leader>rw", "<cmd>FormatWrite<cr>", { desc = "Format+Write current file" })

-- switch buffers and tabs
vim.keymap.set("n", "<leader>m", "<cmd>bnext<cr>", { desc = "Buffer: Next" })
vim.keymap.set("n", "<leader>n", "<cmd>bprev<cr>", { desc = "Buffer: Previous" })
vim.keymap.set("n", "<leader>M", "<cmd>tabnext<cr>", { desc = "Tab: Next" })
vim.keymap.set("n", "<leader>N", "<cmd>tabprev<cr>", { desc = "Tab: Previous" })
-- enter command mode with semicolon (no need to shift)
vim.keymap.set("n", ";", ":", { noremap = true, silent = true, desc = "Enter command-line mode" })
vim.keymap.set("v", ";", ":", { noremap = true, silent = true, desc = "Enter command-line mode" })
-- exit terminal with Esc
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
-- quickfix shortcut
vim.keymap.set("n", "<leader>q", "<cmd>copen<cr>", { desc = "Quickfix" })

-- LSP
require("which-key").add({ { "<leader>l", group = "LSP" } })
vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "<leader>lK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { desc = "Go to References" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Buffer" })
-- trigger completion with Ctrl+Space
vim.keymap.set("i", "<C-Space>", vim.lsp.omnifunc, { noremap = true, silent = true })

-- Auto-save
vim.api.nvim_set_keymap("n", "<leader>ra", ":ASToggle<CR>", { desc = "Auto-save toggle" })

-- ### colorscheme
vim.cmd("silent! colorscheme tokyonight")
vim.o.colorcolumn = "80"
