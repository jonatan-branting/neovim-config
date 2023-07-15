local Popup = require("nui.popup")

local Results = {}

local defaults = {
  bufnr = vim.api.nvim_create_buf(true, false),
  entries = {},
}

function Results:new(opts)
  local results = vim.tbl_extend("force", defaults, opts or {})

  setmetatable(results, self)
  self.__index = self

  return results
end

function Results:refresh()
  vim.schedule(function()
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, self.entries)
  end)
end

-- This is the "default" renderer, which can be passed in via options.
function Results:render()
  self.popup = Popup({
    enter = false,
    focusable = false,
    position = "10%",
    bufnr = self.bufnr,
    size = {
      width = 100,
      height = 50,
    },
  })

  self:start_render_loop()

  self.popup:mount()
  vim.cmd.startinsert()
end

function Results:start_render_loop()
  self.rendering = true
  self:render_loop()
end

function Results:stop_render_loop()
  self.rendering = false
end

function Results:render_loop()
  self:refresh()

  if self.rendering then
    vim.defer_fn(function()
      self:render_loop()
    end, 100)
  end
end

function Results:close()
  self:stop_render_loop()
  self.popup:unmount()
end

return Results
