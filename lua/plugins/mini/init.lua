return {
  "echasnovski/mini.nvim",
  config = function()
    require("plugins.mini.ai")
    require("plugins.mini.trailspace")
    require("plugins.mini.misc")
    require("plugins.mini.session")
    require("plugins.mini.clue")
    require("plugins.mini.bracketed")
    require("plugins.mini.comment")
    require("plugins.mini.notify")
    require("plugins.mini.cursorword")

    require("mini.extra").setup()
  end,
}
