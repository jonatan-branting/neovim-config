-- The Keys module is responsible for handling mappings keys and bindings.
--
-- It will make sure that I'm not overwriting my own mappings (and warn me if I am).
-- It will also allow me to create virtual "modes" such as `select-mode`, which
-- can act as a first-class citizen in my mappings.
--
-- It also makes "desc" mandatory!
--
-- Maybe I also want to support "featuers" which can be mapped. For example, I
-- could have the key "down", which internally translates to "gj", but which
-- allows me to simply reference "down" instead.
-- (I think this is unnecessary)
--
-- But it might be nice given stuff like move-window-left, which can get
-- needlessly abstract when using vim builtins.
-- 
-- This could also allow me to use descriptions

local MODES = { "n", "v", "s", "x", "o", "i", "l", "c", "t" }


local Key = {}
function Key:new(opts)

end

local Keys = {}

local K = {}

local function s()
  -- (K.n .. K.x .. K.buf .. K.map( "j", "gj", "Make j operator on virtual lines instead of \"real\" lines " ))
  -- (K.n .. K.x .. K.buf) ( "j", "gj", "Make j operator on virtual lines instead of \"real\" lines " )
  Keys.n.x.buf
    .desc("Make j operate on virtual lines instead of real lines")
    .map("j", "gj")

  Keys.n.x.buf
    .desc("Grep String")
    .map("<leader>f", require("fzf-lua").grep({search = ""}))

  -- or

  -- This allows me to configure which picker I use in another file
  Keys.n.x.buf
    .desc("Grep String")
    .map("<leader>f", require("config").picker.grep)

  Keys.n
    .desc("Grep String")
    .map("<leader>f", require("config").picker.grep)


  -- TODO: why do this instead of just defining a table?
  Keys.n
    .desc("Tests")
    .group("<leader>t")(function(group)
        group.map("n", config.test_runner.test_nearest)
        group.map("f", config.test_runner.test_file)

        -- This will force visual mode only for `test_selected`, which in turn
        -- will overwrite the groups mode.
        group.x.map("f", config.test_runner.test_selected)
      end
    )

  -- Keys.n.x.buf
  -- or it might be better through a hash
    {
      key = "<leader>",
      desc = "Leader Root",
      group = {
        key = "f",
        desc = "Finder",
        group = {
          key = "f",
          desc = "Find Files",
          run = config.fzf.find_files()
        }
      }
    }
end



function Keys:new()
  local keys = {
    _keys = {},
    _options = { noremap = true, silent = true },
  }


  -- Keys is the metatable here I reckon. But I want to keep using that, along
  -- with dynamically binding it to the corresponding mapping modes, i.e.
  -- Keys.n.map(...) or Keys.n.buf.map(...)
  setmetatable(keys, self)


  -- TODO: but i want to be able to chain these... so I need to be able to "curry" options which all cascasde into a Key once I run "MAP"
  self.__index = function(table, key)
    for _, mode in ipairs(MODES) do
      if key == mode then
        return Key:new({ mode = mode, keys = table })
      end
    end

    -- fallback
    return function(...)
      return self[key](self, ...)
    end
  end

  return keys
end

-- TODO, somehow mode and options will be "curried" here
function Keys:bind(from, to)
  -- TODO: check if from is already bound in this mode. If it's buffer local, then ignore the warning, otherwise `error`!
  vim.keymap.set(self.mode, from, to, self.options)
end

-- We have a "Keys" object, which can return an ephemeral Key object, which registers itself

return Keys
