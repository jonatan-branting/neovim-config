return {
  "NeoGitOrg/neogit",
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      disable_signs = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      auto_refresh = true,
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          -- Adds a mapping with "B" as key that does the "BranchPopup" command
          ["B"] = "BranchPopup",
          -- Removes the default mapping of "s"
        },
      },
    })
  end,
}
