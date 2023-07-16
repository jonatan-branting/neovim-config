local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  sync_install = false,
  auto_install = true,
  context_commentstring = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
  indent = {
    enable = false,
    disable = { "html", "javascript", "lua" },
  },
  yati = {
    enable = false,
    default_lazy = true,
    default_fallback = function(lnum, computed, bufnr)
      local tm_fts = { "lua", "javascript", "python" }
      if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
        return require("tmindent").get_indent(lnum, bufnr) + computed
      end

      return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
    end,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "s",
      node_incremental = "s",
      scope_incremental = "<c-s>",
      node_decremental = "<s-s>",
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = "t",
      toggle_hl_groups = "i",
      toggle_injected_languages = "0",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  -- will be handled by mini.ai instead,
  -- we're only interested in the queries
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.outer",
        ["]b"] = "@block.outer",
        ["]n"] = "@node",
      },
      goto_next_end = {
        ["gef"] = "@function.outer",
        ["gec"] = "@class.outer",
        ["geb"] = "@block.outer",
        ["gen"] = "@node",
      },
      goto_previous_start = {
        ["gsf"] = "@function.outer",
        ["gsc"] = "@class.outer",
        ["gsb"] = "@block.outer",
        ["gsn"] = "@node",
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.outer",
        ["[b"] = "@block.outer",
        ["[n"] = "@node",
      },
      goto_previous_end = {},
    },
    swap = {
      enable = true,
      swap_next = {
        ["<c-l>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<c-h>"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- would be nice with fallbacks here... a lot of keys are required!
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        ["ao"] = "@node",
        ["io"] = "@node",
      },
    },
  },
})
