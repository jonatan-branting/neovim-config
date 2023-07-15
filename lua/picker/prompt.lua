local Popup = require("nui.popup")

local Prompt = {}
Prompt.__index = Prompt

local defaults = {
  bufnr = vim.api.nvim_create_buf(true, false),
  on_input = function() end,
  _history = {},
}

function Prompt:new(opts)
  local prompt = vim.tbl_extend("force", defaults, opts or {})

  setmetatable(prompt, self)

  prompt:setup_autocmds()

  return prompt
end

function Prompt:setup_autocmds()
  vim.api.nvim_create_autocmd(
    "TextChangedI",
    {
      buffer = self.bufnr,
      callback = function()
        local prompt = vim.api.nvim_buf_get_lines(self.bufnr, 0, 1, false)[1]
        table.insert(self._history, prompt)

        self:on_input(prompt)
      end
    }
  )
end

function Prompt:render()
  self.popup = Popup({
    enter = true,
    focusable = true,
    position = "100%",
    bufnr = self.bufnr,
    size = {
      width = 100,
      height = 1,
    },
  })

  self.popup:mount()
end

function Prompt:close()
  self.popup:unmount()
end

return Prompt
