return {
  "vim-test/vim-test",
  config = function()
    local term_integrations = require("modules.term.integrations")

    term_integrations.set_vim_test_strategy()
  end
}
