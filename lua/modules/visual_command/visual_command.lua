local Range = require("modules.lib.range")
local Position = require("modules.lib.position")
local utils = require("utils")

local M = {}

M.marks = {}
M.args = {}
M.save_next_args = false

function M.print_registers()
  print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")))
  print(vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))
end

function M.backup_registers()
  for _, mark in ipairs({ "<", ">" }) do
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, mark))
    M.marks[mark] = { row = row, col = col }
  end
end

function M.restore_registers()
  for mark, data in pairs(M.marks) do
    vim.api.nvim_buf_set_mark(
      0, mark, data.row, data.col, {}
    )
  end
end

function M.execute_cmd_on_targets(cmd, targets, opts)
  M.backup_registers()

  for _,target in ipairs(targets) do
    local start_row, start_col = unpack(target.pos)
    vim.fn.cursor(start_row, start_col)

    vim.fn.setreg("v", cmd)

    -- THIS CAN TRIGGER SIDE EFFECTS SUCH AS OPENING A NEW BUFFER OR OPENING THE FILE PICKER, etc. if you accidentally write a mapping like that... 
    vim.cmd("normal @v")

    if opts.preview then M.highlight(opts.ns) end

    M.restore_registers()
  end
end

function M.highlight(ns)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  local _, start_row, start_col, _= unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  local lines = utils.seq(start_row, end_row)

  if start_row ~= 0 then
    if start_row == end_row then
      vim.api.nvim_buf_add_highlight(
        0, ns, "Visual", start_row - 1, start_col - 1, end_col)
    else
      vim.api.nvim_buf_add_highlight(0, ns, "Visual", start_row - 1, start_col, -1)
      for _, r in ipairs(lines) do
        vim.api.nvim_buf_add_highlight(0, ns, "Visual", r - 1, 1, -1)
      end
      vim.api.nvim_buf_add_highlight(0, ns, "Visual", end_row - 1, 1, end_col)
    end
  end
  vim.api.nvim_buf_add_highlight(0, ns, "Cursor", row - 1, col, col + 1)
end

function M.extract_cmd_from_args(args)
  return args.args
end

function M.maybe_backup_args(args)
  if not M.save_next_args then return end

  M.original_args = args
  M.save_next_args = false
end

function M.heal_arguments(args)
  args.line1 = M.original_args.line1
  args.line2 = M.original_args.line2

  return args
end

function M.get_execute_cmd(target_func, opts)
  opts = vim.tbl_extend("force", {
    preview = false,
  }, opts or {})

  return function(args, ns)
    M.maybe_backup_args(args)
    args = M.heal_arguments(args)

    local cmd = M.extract_cmd_from_args(args)
    opts.ns = ns

    M.execute_cmd_on_targets(
      cmd, target_func(args), opts
    )
  end
end

function M.get_preview_cmd(target_func)
  return function(...)
    M.get_execute_cmd(target_func, { preview = true })(...)

    return 1
  end
end

function M.setup_visual_cmd(name, target_func)
  vim.api.nvim_create_user_command(
    name,
    M.get_execute_cmd(target_func),
    {
      preview = M.get_preview_cmd(target_func),
      nargs = 1,
      range = true,
    }
  )
end

local line_selector = require("modules.visual_command.selectors.line_selector")

M.setup_visual_cmd("Norm", line_selector)

local group = vim.api.nvim_create_augroup("visual_command", {})

vim.api.nvim_create_autocmd("CmdLineEnter",
  {
    group = group,
    callback = function()
      M.save_next_args = true
    end,
  }
)

vim.api.nvim_create_autocmd("CmdLineLeave",
  {
    group = group,
    callback = function()
      M.save_next_args = false
      M.original_args = {}
    end,
  }
)

-- vim.cmd [[ Norm diw ]]

return {
  setup = setup
}
