return {
  "vim-test/vim-test",
  init = function()
    Key.n
      :group("Test", "<leader>t")
      :set("Test nearest", "n", ":TestNearest<cr>")
      :set("Test file", "f", ":TestFile<cr>")
      :set("Test last", "l", ":TestLast<cr>")
      :set("Test visit", "v", ":TestVisit<cr>")
  end,
  config = function()
    local term_integrations = require("modules.term.integrations")

    term_integrations.set_vim_test_strategy()
  end,
}
