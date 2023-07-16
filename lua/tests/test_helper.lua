local M = {}

-- local function use(module, ...)
--   for k,v in pairs(module) do
--     if _G[k] then
--       io.stderr:write("use: skipping duplicate symbol ", k, "\n")
--     else
--       _G[k] = module[k]
--     end
--   end
-- end

function setup_buffer(input, filetype)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", filetype)
  vim.api.nvim_command("buffer " .. buf)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, input)
end

-- local function goToLineRunKeys(line, feedkeys)
--   vim.api.nvim_win_set_cursor(0, { line, 0 })
--   local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
--   vim.api.nvim_feedkeys(keys, "x", false)
-- end
function get_buf_lines()
  return vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
end

function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match(("(.*%s)"):format("/"))
end

-- use(setup_buffer)
-- use(get_buf_lines)
