return {
  "NeoGitOrg/neogit",
  after = "vim-fugitive",
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      auto_refresh = true,
      signs = {
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      mappings = {
        status = {
          ["B"] = "BranchPopup",
        },
      },
    })

    vim.api.nvim_create_autocmd(
    "User",
    {
      pattern = "FugitiveChanged",
      callback = function()
        neogit.refresh_manually()
      end,
    }
    )

  end,
}
