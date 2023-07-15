local Handler = require("modules.term.handler")

local M = {}

setmetatable(M, {
  __index = function(_, key)
    return _G.term_handler[key]
  end,
})

function M.setup()
  _G.term_handler = Handler:new()
end

return M
