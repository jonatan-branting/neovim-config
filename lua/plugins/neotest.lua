-- To actually use this I need to have DAP integration, otherwise it's
-- impossible to run debuggers in the test, which is a _HUGE_ dealbreaker.

return {
  "nvim-neotest/neotest",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-neotest/neotest-plenary" },
    { "nvim-neotest/neotest-python" },
    { "nvim-neotest/neotest-vim-test" },
    { "zidhuss/neotest-minitest" },
    { "haydenmeade/neotest-jest" },
    { "olimorris/neotest-rspec" },
  },
  init = function()
    local Key = require("lib.key")
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "lua",
    --   callback = function(args)
    --     print("Setting up neotest for lua")
    --     vim.keymap.set("n", "<leader>tn", function()
    --       require("neotest").run.run()
    --     end, { buffer = args.buf })
    --     vim.keymap.set("n", "<leader>tf", function()
    --       require("neotest").run.run(vim.fn.expand("%"))
    --     end, { buffer = args.buf })
    --     Key.n:set("Toggle output panel", "<leader>tp", require("neotest").output_panel.toggle)
    --   end,
    -- })
  end,
  config = function()
    require("neotest-minitest")({
      test_cmd = function()
        return vim.tbl_flatten({
          "bundle",
          "exec",
          "rails",
          "test",
        })
      end
    })
    require("neotest").setup({
      log_level = vim.log.levels.DEBUG,
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
        open = true,
      },
      -- consumers = {
      --   function(client) end,
      -- },
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
