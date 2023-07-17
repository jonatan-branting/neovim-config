return {
  "RRethy/vim-illuminate",
  init = function()
    vim.keymap.set({ "x", "n" }, "]]", function()
      require("illuminate").goto_next_reference(false)
    end, {
      desc = "Next Reference",
    })

    vim.keymap.set({ "x", "n" }, "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, {
      desc = "Previous Reference",
    })
    vim.keymap.set({ "o", "v" }, "ii", function()
      require("illuminate").textobj_select()
    end, {
      desc = "Previous Reference",
    })
  end,
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100,
      filetype_overrides = {},
      filetypes_denylist = {
        "dirvish",
        "fugitive",
      },
      filetypes_allowlist = {},
      modes_denylist = {},
      modes_allowlist = {},
      providers_regex_syntax_denylist = {},
      providers_regex_syntax_allowlist = {},
      under_cursor = true,
      large_file_cutoff = nil,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
    })
  end,
}
