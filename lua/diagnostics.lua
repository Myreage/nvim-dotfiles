vim.diagnostic.config({
	-- Show diags in line
	virtual_text = true
})
-- Display diag popup on hover
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
