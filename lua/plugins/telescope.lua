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

    vim.keymap.set("n", "<leader>f", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end)
    vim.keymap.set("n", "<leader>p", function()
      telescope.find_files(get_ivy())
    end)
    vim.keymap.set("n", "<leader>i", function()
      telescope.find_files(get_ivy({ cwd = vim.fn.expand("%:h") }))
    end)
    vim.keymap.set("n", "<leader>e", function()
      telescope.buffers(get_ivy())
    end)
    vim.keymap.set("n", "<leader>,", function()
      telescope.resume(get_ivy())
    end)
    vim.keymap.set("n", "<leader>m", function()
      telescope.oldfiles(get_ivy())
    end)
    vim.keymap.set("n", "<leader><tab>", function()
      telescope.current_buffer_fuzzy_find(get_ivy())
    end)
    vim.keymap.set("n", "<leader>e", function()
      telescope.buffers(get_ivy())
    end)
    vim.keymap.set("n", "<leader>gwc", function()
      require("telescope").extensions.git_worktree.create_git_worktree(get_ivy())
    end)
    vim.keymap.set("n", "<leader>gwl", function()
      require("telescope").extensions.git_worktree.git_worktrees(get_ivy())
    end)
    vim.keymap.set("n", "gr", function()
      telescope.lsp_references(get_ivy())
    end)
    vim.keymap.set("n", "gd", function()
      telescope.lsp_definitions(get_ivy())
    end)
    vim.keymap.set("n", "gw", function()
      telescope.grep_string(get_ivy())
    end)
  end,
  config = function()
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
  end
}

