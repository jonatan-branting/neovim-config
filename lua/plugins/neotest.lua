-- To actually use this I need to have DAP integration, otherwise it's
-- impossible to run debuggers in the test, which is a _HUGE_ dealbreaker.

require("neotest").setup({
  icons = {
    -- I dont like the summary window at all
    expanded = "2",
    child_prefix = "",
    child_indent = "",
    final_child_prefix = "",
    non_collapsible = "",
    collapsed = "",

    passed = "●",
    running = "●",
    failed = "●",
    unknown = "●",
  },
  status = {
    signs = true,
    enabled = true,
    virtual_text = false,
  },
  output = {
    open_on_run = false,
  },
  output_panel = {
    open_on_true = false,
  },
  quickfix = {
    open = false,
  },
  consumers = {
    function(client) end,
  },
  adapters = {
    require("neotest-plenary"),
    -- require("neotest-python")({
    --   dap = {  },
    -- }),
    require("neotest-minitest"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})
