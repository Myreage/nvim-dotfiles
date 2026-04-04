vim.pack.add({"https://github.com/folke/zen-mode.nvim"})
require("zen-mode").setup({
    window = {
    width = 80,             -- largeur idéale pour la prose
    options = {
      spell = true,
      spelllang = "fr,en",
      wrap = true,
      linebreak = true,
    },
  }
})

vim.pack.add({'https://github.com/MeanderingProgrammer/render-markdown.nvim'})
