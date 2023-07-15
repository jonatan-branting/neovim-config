local view = {} --require("picker.views.floating_window")
local Prompt = require("picker.prompt")

-- okay,
local executor = require("picker.sources.rg.executor")

local prompt = Prompt:new({
  on_change = function(prompt)
    executor( f )
  end,
  on_submit = function()
    print("submit")
  end,
})

-- local prompt = view.prompt
-- prompt
-- view.prompt
--

