require("tests.test_helper")

local producer = require("picker.sources.rg.producer")

describe("producer", function()
  it("can handle an empty string", function()
    local prompt = ""

    local result = producer(prompt)

    assert.are.same({ "" }, result)
  end)

  it("converts spaces to wildcards", function()
    local prompt = "foo bar baz"

    local result = producer(prompt)

    assert.are.same("foo.*bar.*baz.*", result)
  end)

  it("converts ! to rg syntax", function()
    local prompt = "bar !foo"

    local result = producer(prompt)

    assert.are.same({ "^(?!.*foo).*bar.*" }, result)
  end)

  it("converts in: to rg syntax", function()
    local prompt = "bar in:foo"

    local result = producer(prompt)

    assert.are.same({ "bar.*", "--iglob", "**foo**" }, result)
  end)

  it("converts !in: to rg syntax", function()
    local prompt = "bar !in:foo"

    local result = producer(prompt)

    assert.are.same({ "bar.*", "--iglob", "**!foo**" }, result)
  end)
end)
