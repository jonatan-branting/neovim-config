local ok, dap = pcall(require, "dap")

if not ok then
  return
end

require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  show_stop_reason = true,
  commented = true,
  only_first_definition = false,
  all_references = false,
  filter_references_pattern = "<module",
  -- experimental features:
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
})

dap.set_log_level("TRACE")
dap.defaults.fallback.terminal_win_cmd = "80vsplit new"
dap.defaults.fallback.auto_continue_if_many_stopped = false

vim.fn.sign_define("DapBreakpoint", { text = "*" })
vim.fn.sign_define("DapStopped", { text = ">" })

dap.adapters.ruby = function(callback, config)
  local handle
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local pid_or_err
  local port = config.port or 38698
  local server = config.server or "127.0.0.1"

  local opts = {
    stdio = { nil, stdout, stderr },
    args = { "--open", "--port", port, "-c", "--", config.program, config.args },
    detached = false,
  }

  handle, pid_or_err = vim.loop.spawn("rdbg", opts, function(code)
    handle:close()
    stdout:close()

    if code ~= 0 then
      print("rdbg exited with code", code)
    end
  end)

  assert(handle, "Error running rdbg: " .. tostring(pid_or_err))

  local on_read = function(err, chunk)
    assert(not err, err)
    if not chunk then
      return
    end

    vim.schedule(function()
      require("dap.repl").append(chunk)

      for _, c in pairs(require("dap").listeners.after["event_output"]) do
        c(nil, chunk)
      end
    end)
  end

  stdout:read_start(on_read)
  stderr:read_start(on_read)

  vim.defer_fn(function()
    callback({
      type = "server",
      host = server,
      port = port,
    })
  end, 500)
end

dap.configurations.rspec = {
  {
    type = "ruby",
    name = "RSpec (current file)",
    request = "launch",
    program = "${workspaceFolder}/bin/rspec",
    localfs = true,
    args = {
      "${file}",
    },
  },
}
dap.configurations.ruby = {
  {
    type = "ruby",
    name = "Minitest (current file)",
    request = "launch",
    program = "rails test",
    localfs = true,
    args = {
      "${file}",
    },
  },
}
