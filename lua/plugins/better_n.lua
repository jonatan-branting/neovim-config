local Key = require("lib.key")

return {
  "jonatan-branting/nvim-better-n",
  lazy = false,
  dev = true,
  enabled = true,
  init = function()
    Key.n.x.expr.nowait
      :set("Next", "n", require("better-n").next)
      :set("Previous", "<s-n>", require("better-n").previous)
  end,
  config = function()
    require("better-n").setup({
    })
  end,
}
