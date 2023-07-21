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
    neogit = true,
    fern = true,
    illuminate = true,
    fidget = true,
  },
  custom_highlights = {},
  color_overrides = {},
})

vim.cmd.colorscheme("catppuccin")
