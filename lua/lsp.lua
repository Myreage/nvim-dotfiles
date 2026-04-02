vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = {
				-- To have vim globals available in lua files
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}

	}
})
vim.lsp.enable({ 'lua_ls', 'rust_analyzer' })


-- Show popup on auto-complete, even if only one element, don't auto insert
vim.opt.completeopt:append({ 'menuone', 'popup', 'noinsert' })

-- Remap ENTER to CTRL+Y when the completion popup menu is open (to accept completion with ENTER instead of CTRL+Y)
vim.keymap.set('i', '<cr>', function()
	return vim.fn.pumvisible() == 1 and '<c-y>' or '<cr>'
end, { expr = true }
)


-- On LSP Attach
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		-- Enable auto-completion if available for client, with auto trigger
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

			-- Trigger completion on CTRL+Space
			vim.keymap.set('i', '<c-space>', function()
				vim.lsp.completion.get()
			end)
		end

		-- Auto-format on save, if available and not auto-enabled by the client.
		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
