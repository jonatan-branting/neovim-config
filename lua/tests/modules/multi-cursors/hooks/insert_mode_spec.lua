require("tests.test_helper")

local utils = require("utils")
local Session = require("modules.multi-cursors.session")

local insert_mode_hooks = require("modules.multi-cursors.hooks.insert_mode")

describe("insert mode hooks", function()
  it("replays insert mode changes to other cursors", function()
    setup_buffer({
      " test1",
      "",
    }, "lua")

    local session = Session:new()
    local cursor1 = session:add_cursor({ 1, 1 })
    session:add_cursor({ 2, 1 })

    session:set_active_cursor(cursor1)
    insert_mode_hooks.setup(session)

    vim.api.nvim_feedkeys(utils.t("iTEST<cr>"), "x", true)
    -- vim.api.nvim_feedkeys(utils.t("i<cr>TEST<cr>"), "x", true)
    assert.are.same({
      "TEST test1",
      "TEST",
    }, get_buf_lines())
  end)
end)
