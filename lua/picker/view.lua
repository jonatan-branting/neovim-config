local View = {}

-- TODO I dont want to implement a proper UI yet...
-- I just want to get the basic functionality down.

local defaults = {
  bufnr = vim.api.nvim_create_buf(false, true),
  entries = {},
}

function View:new(opts)
  local view = vim.tbl_extend("force", defaults, opts or {})

  setmetatable(view, self)
  self.__index = self

  return view
end


return View
