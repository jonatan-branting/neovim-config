-- TODO should fetch what keybinds to use from elsewhere

require("nvim-surround").setup({
  keymaps = {
    normal = "m",
    normal_cur = "mm",
    normal_line = "M",
    visual = "m",
    delete = "md",
    change = "mc",
  },
})
