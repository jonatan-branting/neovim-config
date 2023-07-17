return {
  "jonatan-branting/other.nvim",
  dev = true,
  init = function()
    vim.keymap.set("n", "<leader>r", "<cmd>:Other<CR>", {
      silent = true,
      desc = "Open Other",
    })
  end,
  config = function()
    require("other-nvim").setup({
      mappings = {
        "rails",
        {
          pattern = "/lib/(.*)/(.*).rb$",
          target = "/test/lib/%1/%2_test.rb",
          context = "spec",
        },
        {
          pattern = "/test/lib/(.*)/(.*)_test.rb$",
          target = "/lib/%1/%2.rb",
          context = "spec",
        },
        {
          pattern = "/apps/(.*)/(.*).rb$",
          target = "/test/apps/%1/%2_test.rb",
          context = "spec",
        },
        {
          pattern = "/test/apps/(.*)/(.*)_test.rb$",
          target = "/apps/%1/%2.rb",
          context = "spec",
        },
        {
          pattern = "/lua/tests/(.*)/(.*)_spec.lua$",
          target = "/lua/%1/%2.lua",
          context = "spec",
        },
        {
          pattern = "/lua/(.*)/(.*).lua$",
          target = "/lua/tests/%1/%2_spec.lua",
          context = "spec",
        },
      },
      style = {
        border = "single",
        seperator = "|",
        width = 0.7,
        minHeight = 2,
      },
      rememberBuffers = false,
    })
  end
}
