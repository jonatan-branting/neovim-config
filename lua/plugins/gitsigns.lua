return {
  "lewis6991/gitsigns.nvim",
  init = function()
    Key.n
      :group("Git Hunks", "<leader>h")
      :set("Stage", "s", function()
        require("gitsigns").stage_hunk()
      end)
      :set("Undo staged hunk", "u", function()
        require("gitsigns").undo_stage_hunk()
      end)
      :set("Reset hunk", "r", function()
        require("gitsigns").reset_hunk()
      end)
      :set("Preview hunk", "p", function()
        require("gitsigns").preview_hunk()
      end)
      :set("Reset buffer", "R", function()
        require("gitsigns").reset_buffer()
      end)
      :set("Blame line", "b", function()
        require("gitsigns").blame_line()
      end)
      :set("Next hunk", "n", function()
        if vim.wo.diff then
          vim.cmd("normal ]c")
        else
          require("gitsigns").next_hunk()
        end
      end)
      :set("Previous hunk", "p", function()
        if vim.wo.diff then
          vim.cmd("normal [c")
        else
          require("gitsigns").prev_hunk()
        end
      end)
  end,
  config = function()
    require("gitsigns").setup({
      signcolumn = true,
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 2000,
        virt_text_pos = "eol",
      },
      sign_priority = 6,
      update_debounce = 100,
      attach_to_untracked = false,
      word_diff = false,
      status_formatter = nil,
      diff_opts = {
        internal = true,
      },
    })
  end,
}
