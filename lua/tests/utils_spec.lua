require("tests.test_helper")

local utils = require("utils")
local Range = require("modules.lib.range")

describe(".map_buffer", function()
  it("executes func over a buffer range", function()
    setup_buffer(
      {
        "line 1",
        "line 2",
        "line 3",
        "",
        "line 5",
      },
      "lua"
    )

    local range = Range:new({ 1, 1 }, { 5, 8 })

    local lines = {}
    utils.map_buffer(0, range, function(line)
      table.insert(lines, line)
    end, { linewise = false })

    assert.are.same({
      "line 1",
      "line 2",
      "line 3",
      "",
      "line 5",
    }, lines)
  end)
end)
