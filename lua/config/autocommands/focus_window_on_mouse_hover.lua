local Window = require("window")
local utils = require("utils")

local group = vim.api.nvim_create_augroup("FocusWindowOnHover", {})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MouseHoverEnter",
  callback = function(args)
    local cursor_pos = { args.data.position.screenrow, args.data.position.screencol }

    if Window.current():is_floating() then
      return
    end

    local window = Window.at_pos(cursor_pos)

    if window then
      vim.schedule(function()
        window:focus()
      end)
    end
  end,
})
