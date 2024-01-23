local gen_spec = require("mini.ai").gen_spec

require("mini.ai").setup({
  custom_textobjects = {
    a = gen_spec.argument({ brackets = { "%b()", "%b{}" }, separator = "[,;]" }),
    b = { { "%b[]", "%b()", "%b{}" } },
    d = { "%f[%d]%d+" },
    f = gen_spec.treesitter({
      a = { "@function.outer" },
      i = { "@function.inner" },
    }),
    s = gen_spec.treesitter({
      a = { "@function.outer", "@class.outer" },
      i = { "@function.inner", "@class.inner" },
    }),
    x = { {
      "\n()%s*().-()\n()",
      "^()%s*().-()\n()",
    } },
  },
  mappings = {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "ap",
    inside_last = "ip",
  },
  n_lines = 300,
  search_method = "cover_or_next",
})

