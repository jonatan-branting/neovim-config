vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer", "fern" }
vim.g.tokyonight_style = "night"
vim.g.tokyonight_hide_inactive_statusline = true
vim.g.tokyonight_dark_float = false
vim.g.catppuccin_flavour = "mocha"

require("catppuccin").setup({
  term_colors = true,
})

vim.cmd([[ set bg=dark ]])
vim.cmd([[ colorscheme catppuccin]])
