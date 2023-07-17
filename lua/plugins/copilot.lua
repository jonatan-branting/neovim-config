return {
  "zbirenbaum/copilot.lua",
  event = "VimEnter",
  init = function()
    local suggestion = require("copilot.suggestion")

    -- TODO: Make this work, otherwise normal-mode <c-e> is non-functional
    -- if suggestion.is_visible() then
    -- vim.keymap.set("i", "<c-e>", function()
    --   suggestion.accept()
    -- else
    --   return "<c-o>g$"
    -- end
    -- end, { expr = true })

    vim.keymap.set("i", "<c-p>", function()
      suggestion.prev()
    end)

    vim.keymap.set("i", "<c-n>", function()
      suggestion.next()
    end)
  end,
  config = function()
    vim.defer_fn(function()
      require("copilot").setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept_line = "<c-e>",
            accept = "<c-y>",
            next = "<c-n>",
            prev = "<c-p>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          norg = false,
          svn = false,
          cvs = false,
          ruby = true,
          ["."] = false,
        },
        copilot_node_command = vim.fn.expand("$HOME") .. "/.local/share/nvm/v16.17.1/bin/node",
        plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
        server_opts_overrides = {
          advanced = {
            length = 1,
          },
        },
      })
    end, 100)
  end,
}
