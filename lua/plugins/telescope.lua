local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    borderchars = {
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-k>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<cr>"] = actions.select_default,
        ["<c-p>"] = actions.cycle_history_prev,
        ["<c-n>"] = actions.cycle_history_next,
      },
    },
  },
  pickers = {},
  extensions = {
    git_worktree = {
      git_worktrees = {
        theme = "ivy",
      },
      create_worktree = {
        theme = "ivy",
      },
      theme = "ivy",
    },
    git_worktrees = {
      theme = "ivy",
    },
    live_grep_args = {
      theme = "ivy",
    },
  },
})
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("advanced_git_search")
require("telescope").load_extension("git_worktree")
require("telescope-all-recent").setup({})
