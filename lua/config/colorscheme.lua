require("catppuccin").setup({
  flavour = "mocha",
  term_colors = true,
  styles = {
    comments = { "italic" },
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    treesitter = true,
    notify = true,
    mini = true,
  },
  custom_highlights = {},
  color_overrides = {},
})

vim.cmd([[ set bg=dark ]])
vim.cmd([[ colorscheme catppuccin]])
