return {
  "nvim-neorg/neorg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              work = "~/neorg/work",
              personal = "~/neorg/personal",
            },
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.keybinds"] = {},
        ["core.export"] = {
          config = {
            export_dir = "~/neorg/export"
          }
        },
        ["core.summary"] = {
          config = {
            strategy = "default"
          }
        },
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode"

          }
        },
        ["core.manoeuvre"] = {},
        ["core.esupports.indent"] = {}

      },
    })

    -- When in a .norg file, always run, run indentexpr on InsertLeave
    local augroup = vim.api.nvim_create_augroup("NeorgAutocommands", {})
    vim.api.nvim_create_autocmd(
      "BufEnter",
      {
        group = augroup,
        pattern = "*.norg",
        callback = function()
          local inner_augroup = vim.api.nvim_create_augroup("NeorgAutocommandsIndent", {})
          vim.api.nvim_create_autocmd(
            "InsertLeave",
            {
              group = inner_augroup,
              callback = function() vim.cmd("normal! mn==`n") end,
              buffer = vim.api.nvim_get_current_buf(),
            }
          )
        end
      }
    )
  end,
}
