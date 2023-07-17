return {
  "ThePrimeagen/git-worktree.nvim",
  config = function()
    local worktree = require("git-worktree")
    worktree.setup({
      update_on_change = true,
      clearjumps_on_change = true,
    })

    vim.api.nvim_create_user_command("GW", function(opts)
      local branch_name = opts.args

      require("git-worktree").create_worktree(branch_name, "develop", "origin")
    end, { nargs = 1 })
  end
}
