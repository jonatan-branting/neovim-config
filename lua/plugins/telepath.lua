return {
  "rasulomaroff/telepath.nvim",
  dependencies = "ggandor/leap.nvim",
  lazy = false,
  config = function()
    require("telepath").use_default_mappings()
  end,
}
