-- TODO should fetch what keybinds to use from elsewhere

return {
  "kylechui/nvim-surround",
  config = function()
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
  end,
}
