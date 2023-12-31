local M = {}

function M.setup()
  local hover_time = 240
  local hover_timer = nil
  local position = nil
  vim.o.mousemoveevent = true

  vim.keymap.set({ "", "i" }, "<MouseMove>", function(args)
    if hover_timer then
      hover_timer:close()
    end

    hover_timer = vim.defer_fn(function()
      hover_timer = nil
      position = vim.fn.getmousepos()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "MouseHoverEnter",
        data = { position = vim.fn.getmousepos() },
      })
    end, hover_time)

    vim.api.nvim_exec_autocmds("User", {
      pattern = "MouseHoverLeave",
      data = { position = vim.fn.getmousepos() },
    })

    return "<MouseMove>"
  end, { expr = true })
end

return M
