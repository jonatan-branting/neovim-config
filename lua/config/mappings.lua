local utils = require("lib.utils")
local Enumeratable = require("lib.enumeratable")
local Key = require("lib.key")
local keymap = vim.keymap

local function nnoremap(opts, desc)
  return keymap.set("n", unpack(opts or {}))
end

local function inoremap(opts, desc)
  return keymap.set("i", unpack(opts or {}))
end

local function snoremap(opts, desc)
  return keymap.set("s", unpack(opts or {}))
end

local function cnoremap(opts, desc)
  return keymap.set("c", unpack(opts or {}))
end

local function vnoremap(opts, desc)
  return keymap.set("x", unpack(opts or {}))
end

-- Convenience <leader> mappings
Key.n.silent
  :group("Windows", "<leader>w")
  :set("Right window", "l", "<c-w>l")
  :set("Left window", "h", "<c-w>h")

-- General opinionated behaviour changes
Key.i.s.c:set("Escape", "jj", "<esc>")

Key.n:set("Save file", "<leader>s", "<cmd>w<cr>")

Key.n.expr:set("Up", "k", function()
  if vim.v.count == 0 then
    return "gk"
  end

  return "m'" .. vim.v.count .. "k"
end)

Key.n.expr:set("Down", "j", function()
  if vim.v.count == 0 then
    return "gj"
  end

  return "m'" .. vim.v.count .. "j"
end)

-- TODO Recreate each mapping below the cursor in the Key.<mode> style

Key.x.silent.expr:set("Go up", "k", "(v:count == 0 ? 'gk' : 'k')")
Key.x.silent.expr:set("Go down", "j", "(v:count == 0 ? 'gj' : 'j')")

Key.n.x:set("Go to end of line", "L", "g_")
Key.n.x.silent.expr:set(
  "Go to start of line",
  "H",
  "(getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^')"
)

Key.x.nowait:set("Deindent", "<", "<gv")
Key.x.nowait:set("Indent", ">", ">gv")

-- Allow terminal style navigation in insert mode
Key.i:set("Start of line", "<c-a>", "<c-o>g0")
Key.i:set("End of line", "<c-e>", "<c-o>g$")

Key.v:set("Search and replace", "<c-r>", ":%s///gc<left><left><left>")

-- Consistency please!
Key.n:set("Select line", "vv", "0v$")
Key.n:set("Yank to end of line", "Y", "y$")

-- Windows
Key.n.silent
  :group("Windows", "<leader>w")
  :set("Close window", "d", "<c-w>c")
  :set("Horizontal split", "-", "<c-w>s")
  :set("Vertical split", "/", "<c-w>v")
  :set("Zoom window", "<space>", "<c-w>m")
  :set("Enlargen window left", "H", "<c-w>5<")
  :set("Enlargen window right", "L", "<c-w>5>")
  :set("Semi-rotate layout", "y", "<c-w>H")
  :set("Balance windows", "=", "<c-w>=")

Key.v:set("Visual star", "*", function()
  local search = require("utils").get_visual_selection()

  vim.api.nvim_input([[<esc>]])
  vim.api.nvim_input("/" .. search .. "<cr>")
end)

vim.keymap.set("n", "<leader>gs", "<cmd>Git add %<cr>", { desc = "Git add current file" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git add current file" })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit kind=replace<cr>", { desc = "Git add current file" })

Key.n:set("Reset current file", "<leader>gr", function()
  local default_branch_path = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD")
  local default_branch = Enumeratable:new(vim.split(default_branch_path, "/"))
    :map(function(item)
      return vim.trim(item)
    end)
    :last()

  -- Add current position to jumplist
  vim.cmd("normal m'")

  vim.cmd("Git checkout " .. default_branch .. " -- %")

  print("Checked out " .. vim.fn.expand("%") .. " from " .. default_branch)
end)

-- Easy Align
vnoremap({ "<cr>", "<Plug>(EasyAlign)" }, "easy-align-selected")
nnoremap({ "ga", "<Plug>(EasyAlign)" }, "easy-align")

-- Asterisk
Key.n
  :set("Search word under cursor", "*", "<Plug>(asterisk-*)")
  :set("Search word under cursor backwards", "#", "<Plug>(asterisk-#)")
  :set("Search word under cursor, but don't jump", "g*", "<Plug>(asterisk-g*)")
  :set("Search word under cursor backwards, but don't jump", "g#", "<Plug>(asterisk-g#)")
  :set("Search word under cursor, but don't move cursor", "z*", "<Plug>(asterisk-z*)")
  :set("Search word under cursor, but don't move cursor, backwards", "gz*", "<Plug>(asterisk-gz*)")
  :set("Search word under cursor backwards, but don't move cursor", "z#", "<Plug>(asterisk-z#)")
  :set(
    "Search word under cursor backwards, but don't move cursor, backwards",
    "gz#",
    "<Plug>(asterisk-gz#)"
  )

-- Allow line split using S, as opposed to J(oin)
-- vim.keymap.set("n", 'S', 'i<cr><Esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>')

-- I'm not using this, and I want a free key
nnoremap({ "t", "<nop>" })

-- Nearly same as <cr>
nnoremap({ "_", "<nop>" })

-- Begone
nnoremap({ "Q", "<nop>" })

local todo = require("modules.todo")

-- TODO come up with good context prefix <leader>z is too short
-- nnoremap({ "<leader>z", todo.open_branch_todo }, "open-branch-todo")

nnoremap({ "<c-k>", ":m .-2<CR>==" })
nnoremap({ "<c-j>", ":m .+1<CR>==" })
vnoremap({ "<c-k>", ":m '<-2<CR>gv=gv" })
vnoremap({ "<c-j>", ":m '>+1<CR>gv=gv" })

vnoremap({ "<up>", ":m '<-2<CR>gv=gv" })
vnoremap({ "<down>", ":m '>+1<CR>gv=gv" })
vnoremap({ "<left>", "<gv" })
vnoremap({ "<right>", ">gv" })

nnoremap({ "<down>", "<c-w>j" })
nnoremap({ "<up>", "<c-w>k" })
nnoremap({ "<left>", "<c-w>h" })
nnoremap({ "<right>", "<c-w>l" })

nnoremap({ "<s-down>", require("smart-splits").resize_down })
nnoremap({ "<s-up>", require("smart-splits").resize_up })
nnoremap({ "<s-left>", require("smart-splits").resize_left })
nnoremap({ "<s-right>", require("smart-splits").resize_right })

nnoremap({ "<c-a>", "0" })
nnoremap({ "<c-e>", "$" })

nnoremap({ "<leader>a", "<c-^>" }, "alternate-last-buffer")

nnoremap({ "yc", "<c-w>c" }, "close-window")

inoremap({ ";;", "<esc>A;<esc>" })
inoremap({ ",,", "<esc>A,<esc>" })

vim.keymap.set("n", "<leader>vr", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

cnoremap({ "<c-x>", "<c-v><esc>" })
vnoremap({ "<tab>", '"zc' })

vim.keymap.set("x", "p", "pgvy=']", {})
vim.keymap.set({ "x", "n" }, "p", "p=']", {})
vim.keymap.set({ "x", "n" }, "gh", "^", {})
vim.keymap.set({ "x", "n" }, "gl", "$", {})

vim.keymap.set({ "n", "x" }, "<s-n>", require("better-n").shift_n, { nowait = true })
vim.keymap.set({ "n", "x" }, "n", require("better-n").n, { nowait = true })

vim.keymap.set({ "n", "o", "x" }, "<c-w>", "w")
vim.keymap.set("i", "jj", "<esc>")

-- dont overwrite clipboard when pasting from visual mode
-- vim.keymap.set("n", "<cr>", "o<esc>0\"_D")
-- vim.keymap.set("n", "<s-cr>", "O<esc>0\"_D")

vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")

-- clear line, but keep it
vim.keymap.set("n", "X", "ddO<esc>")

-- searches for the last text that was changed, and replaces it with the changes made
-- is dot repeatable

_G.search_and_replace_last_wrapper = function()
  vim.go.operatorfunc = "v:lua.search_and_replace_last_callback"

  return "g@l"
end

_G.search_and_replace_last_dummy = function()
  -- nop
end

_G.search_and_replace_last_callback = function()
  vim.fn.execute(utils.t("normal! /<c-r>*<cr>gnc<c-r>.<esc>"))

  -- make sure that . will repeat g@l, instead of the change command
  -- execute nothing, however
  vim.go.operatorfunc = "v:lua.search_and_replace_last_dummy"
  vim.fn.execute("normal g@l")

  -- set the operatorfunc back to the callback, so that dot repeat will work
  vim.go.operatorfunc = "v:lua.search_and_replace_last_callback"
end

vim.keymap.set("n", "<leader>.", search_and_replace_last_wrapper, { expr = true })

-- if this is done in a visually selected area, repeat it for all occurrences in that area
vim.keymap.set("v", "<leader>.", ":s/<c-r>*/<c-r>./gc<cr>")
vim.keymap.set("n", "<c-y>", "<cmd>nohl<cr>")

vim.keymap.set("n", "<leader-b>", function()
  vim.fn.setreg("/", vim.fn.getreg("*"))
  vim.cmd([[ set hls ]])
end)

vim.keymap.set("n", "V", "v$")
vim.keymap.set("n", "vv", "V")

-- Populate jumplist on insert mode!
vim.keymap.set("n", "i", "m'i")

-- vim.keymap.set("n", "J", "Jx")
vim.keymap.set("x", "/", "<Esc>/\\%V")
vim.keymap.set({ "n", "x" }, "<cr>", ":")
vim.keymap.set({ "n", "x" }, "<s-cr>", ":%")
vim.keymap.set({ "n" }, "x", "/")
vim.keymap.set({ "x" }, "x", "<esc>/\\%V")

-- join but remove whitespace
vim.keymap.set("n", "J", function()
  vim.cmd("normal! mzJ")

  local col = vim.fn.col(".")
  local context = string.sub(vim.fn.getline("."), col - 1, col + 1)
  if
    context == ") ."
    or context == ") :"
    or context:match("%( .")
    or context:match(". ,")
    or context:match("%w %.")
  then
    vim.cmd("undojoin | normal! x")
  elseif context == ",)" then
    vim.cmd("undojoin | normal! hx")
  end

  vim.cmd("normal! `z")
end)

vim.keymap.set("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, {
  expr = true,
})

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, {
  expr = true,
})

vim.keymap.set("n", "<leader>l", function()
  require("modules.term"):get_terminal():toggle()
end)
vim.keymap.set({ "n", "x" }, "<leader>x", function()
  -- TODO we can likely expand this to language specific mappings, which might wrap things
  -- to auto-monkey-patch stuff in Ruby, for example, by using Treesitter

  require("modules.term"):get_terminal():send(vim.fn.getline("."))
end)
vim.keymap.set("n", "<leader>l", function()
  require("modules.term"):get_terminal():toggle()
end)

-- vim.keymap.set('n', 'o', function()
--   local line = vim.api.nvim_get_current_line()

--   local should_add_comma = string.find(line, '[^,{[]$')
--   if should_add_comma then
--     return 'A,<cr>'
--   else
--     return 'o'
--   end
-- end, { buffer = true, expr = true })

-- TODO also make f go cross lines
