return {
  "chomosuke/term-edit.nvim",
  config = function()
    require("term-edit").setup({
      prompt_end = "%› "
    })
  end
}
