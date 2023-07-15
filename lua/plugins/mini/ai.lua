local gen_spec = require("mini.ai").gen_spec
require("mini.ai").setup({
  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = {
    -- argument
    a = gen_spec.argument({ brackets = { "%b()", "%b{}" }, separator = '[,;]' }),
    b = { {"%b[]", "%b()", "%b{}" } },
    -- digits
    d = { '%f[%d]%d+' },
    -- diagnostics (errors)
    f = gen_spec.treesitter({
        a = { "@function.outer" },
        i = { "@function.inner" },
      }
    ),
    -- scope
  s = gen_spec.treesitter({
        a = { "@function.outer", "@class.outer" },
        i = { "@function.inner", "@class.inner" },
      }
    ),
    x = { {
      '\n()%s*().-()\n()',
      '^()%s*().-()\n()'
    } },
    -- WORD
    -- W = { {
    --   '()()%f[%w%p][%w%p]+()[ \t]*()',
    -- } },
    -- word
    -- w = { '()()%f[%w]%w+()[ \t]*()' },
    -- key or value (needs a lot of work)
    -- z = gen_spec.argument({ brackets = { '%b()'}, separators = {',', ';', '=>'}}),
    -- chunk (as in from vim-textobj-chunk)
    -- z = {
    --     '\n.-%b{}',
    --     '\n().-%{\n().*()\n.*%}()'
    -- },
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',
    -- Next/last textobjects
    around_next = 'an',
    inside_next = 'in',
    around_last = 'ap',
    inside_last = 'ip',
    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },
  -- Number of lines within which textobject is searched
  n_lines = 300,
  -- How to search for object (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
  search_method = 'cover_or_next',
})

-- for _, k in ipairs({ "]", "}", ">", "o", "f", "r", "b" }) do
--   for _, mode in ipairs({ 'n', 'x', 'o' }) do
--     vim.api.nvim_set_keymap(
--       mode, ']' .. k, [[<Cmd>lua MiniAi.move_cursor('left', 'a',']]  .. vim.fn.escape(k, "'") .. [[', { search_method = 'next' })<CR>]], {}
--     )
--     -- print([[<Cmd>lua MiniAi.move_cursor('left', 'a',']]  .. vim.fn.escape(k, "'") .. [[', { search_method = 'next' })<CR>]])
--     -- print([[<Cmd>lua MiniAi.move_cursor('left', 'a',]]  .. k .. [[, { search_method = 'next' })<CR>]])
--   end
-- end


