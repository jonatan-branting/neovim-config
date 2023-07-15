require("better-n").setup({
  callbacks = {
    mapping_executed = function(_, key)
      if key == "n" then
        return
      end

      -- Clear highlighting, indicating that `n` will not goto the next
      -- highlighted search-term
      vim.cmd([[ nohl ]])
    end,
  },
  mappings = {
    ["]h"] = { previous = "[h", next = "]h" },
    ["[h"] = { previous = "[h", next = "]h" },

    ["]m"] = { previous = "[m", next = "]m" },
    ["[m"] = { previous = "[m", next = "]m" },

    ["]r"] = { previous = "[r", next = "]r" },
    ["[r"] = { previous = "[r", next = "]r" },

    ["]a"] = { previous = "[a", next = "]a" },
    ["[a"] = { previous = "[a", next = "]a" },

    ["]f"] = { previous = "[f", next = "]f" },
    ["[f"] = { previous = "[f", next = "]f" },

    ["]n"] = { previous = "[n", next = "]n" },
    ["[n"] = { previous = "[n", next = "]n" },

    ["]d"] = { previous = "[d", next = "]d" },
    ["[d"] = { previous = "[d", next = "]d" },

    ["]q"] = { previous = "[q", next = "]q" },
    ["[q"] = { previous = "[q", next = "]q" },

    ["]b"] = { previous = "[b", next = "]b" },
    ["[b"] = { previous = "[b", next = "]b" },

    ["]c"] = { previous = "[c", next = "]c" },
    ["[c"] = { previous = "[c", next = "]c" },

    -- Why does this not work? :o
    ["]]"] = { previous = "[[", next = "]]" },
    ["[["] = { previous = "[[", next = "]]" },

    ["<leader>hn"] = { previous = "<leader>hp", next = "<leader>hn" },
    ["<leader>hp"] = { previous = "<leader>hp", next = "<leader>hn" },

    ["<leader>bn"] = { previous = "<leader>bp", next = "<leader>bn" },
    ["<leader>bp"] = { previous = "<leader>bp", next = "<leader>bn" },

    ["<leader>un"] = { previous = "<leader>up", next = "<leader>un" },
    ["<leader>up"] = { previous = "<leader>up", next = "<leader>un" },
  },
})
