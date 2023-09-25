return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "aaronhallaert/ts-advanced-git-search.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
    { "prochri/telescope-all-recent.nvim" },
    { "nvim-telescope/telescope-dap.nvim" },
  },
  init = function()
    local telescope = require("telescope.builtin")

    local themes = require("telescope.themes")
    local get_ivy = function(opts)
      local default_opts = {
        borderchars = {
          preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        },
      }
      return themes.get_ivy(vim.tbl_deep_extend("force", default_opts, opts or {}))
    end

    Key.n:set("Grep string", "<leader>f", function()
      require("telescope").extensions.live_grep_args.live_grep_args(get_ivy())
    end)
    Key.n:set("Find files", "<leader>p", function()
      require("telescope.builtin").find_files(get_ivy())
    end)
    Key.n:set("Find files in current directory", "<leader>i", function()
      require("telescope.builtin").find_files(get_ivy({ cwd = vim.fn.expand("%:h") }))
    end)
    Key.n:set("Find buffers", "<leader>e", function()
      require("telescope.builtin").buffers(get_ivy())
    end)
    Key.n:set("Resume last search", "<leader>,", function()
      require("telescope.builtin").resume(get_ivy())
    end)
    Key.n:set("Find old files", "<leader>m", function()
      require("telescope.builtin").oldfiles(get_ivy())
    end)
    Key.n:set("Find in current buffer", "<leader><tab>", function()
      require("telescope.builtin").current_buffer_fuzzy_find(get_ivy())
    end)
    Key.n:set("Create git worktree", "<leader>gwc", function()
      require("telescope").extensions.git_worktree.create_git_worktree(get_ivy())
    end)
    Key.n:set("List git worktrees", "<leader>gwl", function()
      require("telescope").extensions.git_worktree.git_worktrees(get_ivy())
    end)
    Key.n:set("Go to references", "gr", function()
      require("telescope.builtin").lsp_references(get_ivy())
    end)
    Key.n:set("Go to definitions", "gd", function()
      require("telescope.builtin").lsp_definitions(get_ivy())
    end)
    Key.n:set("Grep word under cursor", "gw", function()
      require("telescope.builtin").grep_string(get_ivy())
    end)

  end,
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git", ".*/__generated__/.*" },
        theme = "ivy",
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
  end,
}
