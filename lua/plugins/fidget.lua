return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  config = function()
    require("fidget").setup({
      window = {
        blend = 100,
        relative = "editor",
      },
      fmt = {
        stack_upwards = false,
      },
    })
  end
}
