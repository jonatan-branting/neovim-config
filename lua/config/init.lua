-- Manually require local modules
require("modules.mouse_hover").setup()
require("modules.term").setup()
require("modules.popup").setup()

local Enumeratable = require("lib.enumeratable")
local root = vim.fn.stdpath("config") .. "/lua/config"

-- Load everything under `config/`
Enumeratable:new({
  unpack(vim.fn.split(vim.fn.globpath(root, "*.lua"), "\n")),
  unpack(vim.fn.split(vim.fn.globpath(root, "**/*.lua"), "\n")),
})
  :map(function(path)
    return string.gsub(path, vim.fn.stdpath("config") .. "/lua/", "")
  end)
  :map(function(path)
    return string.gsub(path, ".lua$", "")
  end)
  :map(function(path)
    return string.gsub(path, "/", ".")
  end)
  :reject(function(path)
    return string.match(path, "config.init")
  end)
  :map(function(path)
    require(path)
  end)
