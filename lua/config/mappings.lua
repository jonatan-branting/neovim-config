local utils = require("lib.utils")
local Enumeratable = require("lib.enumeratable")
local Key = require("lib.key")

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
-- Key.i:set("End of line", "<c-e>", "<c-o>g$")

Key.v:set("Search and replace", "<c-r>", ":%s///gc<left><left><left>")

-- Consistency please!
Key.n:set("Select line", "vv", "0v$")
Key.n:set("Yank to end of line", "Y", "y$")
Key.n:set("Visual to end of line", "V", "v$")
Key.n:set("Visual entire line", "vv", "V")

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

Key.n.silent
  :group("Git", "<leader>g")
  :set("Stage file", "s", "<cmd>Git add %<cr>")
  :set("Stage all", "S", "<cmd>Git add -u<cr>")
  :set("Commit", "c", "<cmd>Neogit commit<cr>")
  :set("Open Neogit", "g", "<cmd>Neogit kind=replace<cr>")

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

-- Asterisk, include in plugin spec instead
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

-- Nearly same as <cr>
Key.n:set("Unmap _", "_", "<nop>")

-- This is horrible
Key.n:set("Unmap Q", "Q", "<nop>")

-- TODO can we treat modules as local plugins and make this part of a
-- lazy spec instead?
Key.n:set("Open branch todo", "<leader>z", function()
  require("modules.todo").open_branch_todo()
end)

Key.n:set("Alternate last buffer", "<leader>a", "<c-^>")

Key.n:set("Move line up", "<c-k>", ":m .-2<CR>=="):set("Move line down", "<c-j>", ":m .+1<CR>==")

Key.v
  :set("Move line up", "<c-k>", ":m '<-2<CR>gv=gv")
  :set("Move line down", "<c-j>", ":m '>+1<CR>gv=gv")

Key.v
  :set("Move line up", "<up>", ":m '<-2<CR>gv=gv")
  :set("Move line down", "<down>", ":m '>+1<CR>gv=gv")
  :set("Deindent line", "<left>", "<gv")
  :set("Indent line", "<right>", ">gv")

Key.n
  :set("Window left", "<c-h>", "<c-w>h")
  :set("Window down", "<c-j>", "<c-w>j")
  :set("Window up", "<c-k>", "<c-w>k")
  :set("Window right", "<c-l>", "<c-w>l")

Key.n
  :set("Window left", "<left>", "<c-w>h")
  :set("Window down", "<down>", "<c-w>j")
  :set("Window up", "<up>", "<c-w>k")
  :set("Window right", "<right>", "<c-w>l")


-- TODO this should just be part of the context menu!
vim.keymap.set("n", "<leader>nr", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

vim.keymap.set("x", "p", "pgvy=']", {})
vim.keymap.set({ "x", "n" }, "p", "p=']", {})
vim.keymap.set({ "x", "n" }, "gh", "^", {})
vim.keymap.set({ "x", "n" }, "gl", "$", {})

vim.keymap.set({ "n", "o", "x" }, "<c-w>", "w")
vim.keymap.set("i", "jj", "<esc>")

Key.t:set("Leave terminal mode", "<esc>", "<c-\\><c-n>")
Key.n:set("Scroll page down", "<c-d>", "<c-d>zz")
Key.n:set("Scroll page up", "<c-u>", "<c-u>zz")

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
Key.v:set("Replay change", "<leader>.", "<esc>:s/<c-r>*/<c-r>./gc<cr>")

vim.keymap.set("x", "/", "<Esc>/\\%V")
vim.keymap.set({ "n" }, "x", "/")
vim.keymap.set({ "x" }, "x", "<esc>/\\%V")

-- Join but remove whitespace
Key.n:set("Join lines removing whitespace", "J", function()
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

Key.n.expr
  :set("Indent aware delete", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
      return '"_dd'
    else
      return "dd"
    end
  end)
  :set("Indent aware insert", "i", function()
    vim.schedule(function()
      vim.cmd("normal! m'") -- Populate jumplist
    end)
    if #vim.fn.getline(".") == 0 then
      return [["_cc]]
    else
      return "i"
    end
  end)

Key.n
  :set("Send line to terminal", "<leader>x", function()
    require("modules.term"):get_terminal():send(vim.fn.getline("."))
  end)
  :set("Toggle terminal", "<leader>l", function()
    require("modules.term"):get_terminal():toggle()
  end)

Key.n
  :set("Sync cwd with terminal", "<leader>cd", function()
    require("modules.term"):get_terminal():send("cd " .. vim.fn.getcwd())
  end)
Key.n
:set("Run current file in terminal", "<leader>cr", function()
  require("modules.term"):get_terminal():send(vim.fn.expand("%:p"))
end)

Key.t:set("Paste", "<d-v>", "<c-\\><c-n>\"+pgi")
Key.n:set("Paste", "<d-v>", "\"+p")
Key.c:set("Paste", "<d-v>", "<c-r>+")
Key.v:set("Paste", "<d-v>", "\"+p")
