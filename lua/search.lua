vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
-- Search in files
vim.keymap.set('n', '<leader>ff', function()
	require("fzf-lua").files()
end)
