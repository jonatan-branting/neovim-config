require("tests.test_helper")

local handler = require("modules.term.handler")

describe("#toggle", function()
  before_each(function()
    setup_buffer(
      {
        "test_text_row_1",
        "test_text_row_2",
      },
      "lua"
    )
  end)
end)
