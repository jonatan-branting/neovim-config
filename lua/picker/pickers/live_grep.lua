-- 1. a picker is spawned inside of a view, which is triggered by running require("picker.pickers.live_grep).open({view = <some-view>, ...)

local Prompt = require("picker.prompt")
local Results = require("picker.results")

local parser = require("picker.sources.rg.parser")
local executor = require("picker.sources.rg.executor")

local M = {}

function M:new()
  local m = {
    results = nil,
    prompt = nil,
    job = nil,
    entries = {},
  }

  setmetatable(m, self)
  self.__index = self

  return m
end

function M:output_handler(_, data)
  if #self.entries > 100 then
    return
  end

  table.insert(self.entries, parser(data))

  self.results.entries = self.entries
end


function M:input_handler(input)
  -- This job handling should be abstracted.
  if self.job then self.job:_shutdown(0, 2) end

  -- Immediately resetting results.entries here results in flickering, as we
  -- have not yet received new results replacing the old ones.
  --
  -- So we need to wait until we have received the new results before we
  -- replace the old entries with new ones.
  self.entries = {}

  self.job = executor({
    prompt = input,
    on_stdout = function(_, data) self:output_handler(_, data) end,
  })
  self.job:start()
end


-- These should be passed in from the outside
function M:setup_keymaps()
  vim.keymap.set("i", "<cr>", function()
  end, { buffer = self.prompt.bufnr })

  vim.keymap.set({ "n", "i" }, "<esc>", function()
    self:close()
  end, { buffer = self.prompt.bufnr })
end

function M:close()
  self.prompt:close()
  self.results:close()
end

-- This is true for all pickers
-- TODO: Maybe trigger autocmds here?
function M:open()
  self.prompt = Prompt:new({
    on_input = function(_, input) self:input_handler(input) end,
  })
  self.results = Results:new()

  self:setup_keymaps()

  self.results:render()
  self.prompt:render()
end

return M
