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
