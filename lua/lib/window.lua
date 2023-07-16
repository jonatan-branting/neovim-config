local Enumeratable = require("lib.enumeratable")

local Window = {}

function Window.current()
  return Window:new(vim.api.nvim_get_current_win())
end

function Window.all()
  return Enumeratable
    :new(vim.api.nvim_list_wins())
    :map(function(winnr) return Window:new(winnr) end)
end

function Window.at_pos(pos)
  return Window
    :all()
    :find(function(window) return window:contains_pos(pos) end)
end

function Window:new(winnr)
  local instance = {
    winnr = winnr,
  }

  setmetatable(instance, self)
  self.__index = self

  return instance
end

function Window:buffer()
  local Buffer = require("lib.buffer")

  return Buffer:new(vim.api.nvim_win_get_buf(self.winnr))
end

function Window:focus()
  return vim.api.nvim_set_current_win(self.winnr)
end

function Window:is_floating()
  return vim.api.nvim_win_get_config(self.winnr).relative ~= ""
end

function Window:contains_pos(pos)
  local row, col = unpack(pos)

  local win_row, win_col = unpack(vim.api.nvim_win_get_position(self.winnr))
  local win_height, win_width = unpack({
    vim.api.nvim_win_get_height(self.winnr),
    vim.api.nvim_win_get_width(self.winnr),
  })

  if win_row <= row and row <= win_row + win_height and win_col <= col and col <= win_col + win_width then
    return true
  end

  return false
end

return Window
