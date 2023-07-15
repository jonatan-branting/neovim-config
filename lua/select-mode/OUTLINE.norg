@document.meta
  title: select-mode outline
@end

= TOC

* Tracking/triggering motions
  There are a few options here, but none of them are super robust.

** Overloading all relevant bindings
   For example, we could (for /all/ motions), wrap them in a sort of proxy
   object, which will execute the motion and then run the selected `selector`.

   This could look like:

   @code lua
   local Position = require("modules.lib.position")
   local SM = require("select-mode")
   local utils = require("utils")

   local function overload_motion(motion, selector)
     -- This will luckily never be overwritten.
     local plug_mapping = "<plug>(select-mode)" .. motion
     vim.keymap.set("n", plug_mapping, motion, { silent = true })

     return function()
       local pos_before = Position:new({vim.api.nvim_get_cursor(0)})
       -- TODO: I'd like to be able to "trigger" the rhs of a keymap here,
       -- without relying on feedkeys.
       vim.api.nvim_feedkeys(utils.t(plug_mapping), "n", false)

       local pos_after = Position:new({vim.api.nvim_get_cursor(0)})

       selector(pos_before, pos_after)
     end
   end
   @end

   This would just be the first layer of abstraction, be we could perhaps
   extract `vim.keymap.set` into something else, allowing us to do something
   like `keymap.{i, n, s, x, ...}.set`, where `s` would be (our custom)
   `select-mode`, instead of the built in one.

** Running `select` on CursorMoved
   This would allow us to 

* Selecting text
  To actually select something after a movement has been made, we need to know:

  1. where we came from
  2. where we are now
  3. the motion used (or rather, the selector mapped to that specific motion)

  I would want to be able to reuse existing text-objects here. Which means
  triggering mappings using feedkeys (i.e. set opfunc to our selector (which is
  the same thing we bind manually to m) and then we execute that post jump).

This means I kind of need to support both a lua only API, as well as a "enter
  mapping here" API-mode.

  > I do wonder, can I trigger the ´rhs´ of a mapping without using `feedkeys`?
  > Answer is kind of no. For lua-functions: yes, for built in vim-mappings, no.

  We could treat that as possible (and write a wrapper for non-keymapped
  text-objects which uses feedkeys internally), and trigger the rhs of a coupled
  text object
