-- To actually use this I need to have DAP integration, otherwise it's
-- impossible to run debuggers in the test, which is a _HUGE_ dealbreaker.

return {
  "nvim-neotest/neotest",
  dependencies = {
    { "nvim-neotest/neotest-plenary" },
    { "nvim-neotest/neotest-python" },
    { "nvim-neotest/neotest-vim-test" },
    { "zidhuss/neotest-minitest" },
    { "haydenmeade/neotest-jest" },
    { "olimorris/neotest-rspec" },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function(args)
        vim.keymap.set("n", "<leader>tn", function()
          require("neotest").run.run()
        end, { buffer = args.buf })
        vim.keymap.set("n", "<leader>tf", function()
          require("neotest").run.run(vim.fn.expand("%"))
        end, { buffer = args.buf })
      end,
    })
  end,
  config = function()
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
  end,
}
