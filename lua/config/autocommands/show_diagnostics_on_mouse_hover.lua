local Popup = require("nui.popup")
local Window = require("window")
local Enumeratable = require("enumeratable")

local event = require("nui.utils.autocmd").event
-- TODO support for debugger! i.e. make different providers

-- TODO: add syntax highlighting based on severity here.
local function build_lines(diagnostics)
  local lines = {}

  -- TODO highlight
  -- TODO cannot contain newlines apparently, fix this
  for i, diagnostic in ipairs(diagnostics) do
    local line = i .. "." .. diagnostic.message

    if diagnostic.source then
      line = line .. " (" .. diagnostic.source .. ")"
    end

    table.insert(lines, line)
    table.insert(lines, "")
  end

  return lines
end

local function create_diagnostics_window_at_screen_pos(diagnostics, pos)
  local lines = build_lines(diagnostics)

  local max_width = 56
  local max_line_length = 0
  local rows = 0
  for _, line in ipairs(lines) do
    rows = rows + math.ceil(#line / max_width)
    max_line_length = math.max(max_line_length, #line)
  end

  local popup = Popup({
    enter = false,
    focusable = true,
    relative = "editor",
    border = {
      style = "single",
    },
    position = {
      row = pos[1],
      col = pos[2],
    },
    size = {
      height = math.min(rows, 10),
      width = math.min(max_line_length + 1, max_width), -- should depend on the message
    },
  })

  vim.api.nvim_create_autocmd({
    "WinScrolled",
    "TextChanged",
    "TextChangedI",
    "ModeChanged",
  }, {
    once = true,
    callback = function()
      vim.schedule(function()
        popup:unmount()
      end)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MouseHoverLeave",
    once = true,
    callback = function()
      vim.schedule(function()
        popup:unmount()
      end)
    end,
  })
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  popup:mount()

  vim.api.nvim_win_set_option(popup.winid, "wrap", true)
  vim.api.nvim_win_set_option(popup.winid, "breakindent", true)
  vim.api.nvim_win_set_option(popup.winid, "breakindentopt", "shift:3,min:40,sbr")

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MouseHoverEnter",
  callback = function(args)
    local cursor_screen_pos = { args.data.position.screenrow, args.data.position.screencol }
    local cursor_win_pos = { args.data.position.line - 1, args.data.position.column }
    local _, col = unpack(cursor_win_pos)

    local window = Window.at_pos(cursor_screen_pos)

    if not window then
      return
    end

    local bufnr = window:buffer().bufnr
    local line_diagnostics =
      Enumeratable:new(vim.diagnostic.get(bufnr, { lnum = cursor_win_pos[1] }))

    local diagnostics = line_diagnostics:select(function(diagnostic)
      return diagnostic.col <= col + 1 and diagnostic.end_col + 1 >= col
    end)

    if diagnostics:any() then
      create_diagnostics_window_at_screen_pos(diagnostics:to_table(), cursor_screen_pos)
    end
  end,
})
