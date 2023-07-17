return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    { "kevinhwang91/promise-async" },
  },
  config = function()
    require("bqf").setup({
      auto_enable = true,
    })
  end,
}
