require("tests.test_helper")

local executor = require("picker.sources.rg.executor")

-- TODO: How do I mock ´rg´ results?
describe("executor", function()
  it("runs a command", function()
    local prompt = "foo !baz in:baz"

    -- TODO: Either mock results, or extract nvim config to another repository, with a more clear root.
    local cwd = (vim.loop.cwd() .. "/config/nvim/lua/tests/fixtures/foo")

    local result = {}
    local job = executor({
      prompt = prompt,
      cwd = cwd,
      on_stdout = function(_, data)
        table.insert(result, data)
      end,
    })

    job:sync()
    job:_shutdown(0, 2)

    assert.are.same(
      { "./baz.txt:bartestfoo" },
      result
    )
  end)
end)
