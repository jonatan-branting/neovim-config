-- This module enables the following syntax to be used for mapping keys:
-- ```
-- Key.n:set("Save file", "<leader>s", ":w<cr>")
-- Key.n
--   :group("File", "<leader>f")
--   :set("Save file", "s", ":w<cr>")
--   :set("Delete file", "d", ":Delete %<cr>")
-- ```

local Key = {}

-- This allows us to use `Key.n` instead of `Key:new().n`
setmetatable(Key, {
  __index = function(_, k)
    -- TODO: This stack-overflows when we try to access a key that
    -- doesn't exist
    return Key:new()[k]
  end,
})

function Key:new()
  local instance = {
    modes = {},
    flags = {},
    _group = "",
  }

  setmetatable(instance, self)

  -- This allows us to chain modes like this : `Key.n.o.x`
  self.__index = function(_, k)
    local possible_modes = {
      n = "n",
      i = "i",
      v = "v",
      x = "x",
      o = "o",
      t = "t",
      c = "c",
      s = "s",
      l = "l",
      ["!"] = "!",
    }

    local possible_flags = {
      silent = { silent = true },
      expr = { expr = true },
      nowait = { nowait = true },
    }

    if possible_modes[k] ~= nil then
      table.insert(instance.modes, possible_modes[k])
      return instance
    elseif possible_flags[k] ~= nil then
      instance.flags = vim.tbl_extend("force", instance.flags, possible_flags[k])
      return instance
    else
      return self[k]
    end
  end

  return instance
end

function Key:__call(...)
  return self.set(...)
end

function Key:group(desc, group)
  -- TODO: Add a way to set the group description, possibly this is which-key specific
  self._group = group

  return self
end

function Key:set(desc, key, value)
  local opts = vim.tbl_extend("force", self.flags, { desc = desc })
  vim.keymap.set(self.modes, self._group .. key, value, opts)

  return self
end

return Key
