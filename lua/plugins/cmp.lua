local cmp = require("cmp")
local lspkind = require("lspkind")
local utils = require("utils")

local should_autocomplete = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]

  local before_char = line_content:sub(col, col)
  local after_char = line_content:sub(col + 1, col + 1)

  local has_words_before = col ~= 0 and before_char:match("%s") == nil
  local is_in_parens = after_char:match("[%]%}%)]")

  return has_words_before and not is_in_parens
end

vim.opt.completeopt = "menu,menuone,noinsert"

local compare = cmp.config.compare

local types = require("cmp.types")

local tab = function(fallback)
  if cmp.visible() then
    cmp.confirm({ select = true })
  else
    fallback()
  end
end

cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      or require("cmp_dap").is_dap_buffer()
  end,
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind

      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        treesitter = "[Treesitter]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })[entry.source.name]

      vim_item.dup = ({
        nvim_lsp = 1,
      })[entry.source.name] or 0

      return vim_item
    end,
  },
  -- view = {
  --   entries = "wildmenu",
  -- },
  experimental = {
    ghost_text = false,
  },
  completion = {
    -- keyword_length = 1,
    -- autocomplete = false,
    -- completeopt = 'menu,menuone,noinsert',
  },
  preselect = cmp.PreselectMode.Item,
  sorting = {
    priority_weight = 1.0,
    comparators = {
      -- require("copilot_cmp.comparators").prioritize,
      -- require("copilot_cmp.comparators").score,

      compare.score,
      compare.kind,
      compare.offset,
      compare.exact,
      -- function(a, b)
      compare.length,
      --   local a_kind = types.lsp.CompletionItemKind[a:get_kind()]
      --   local b_kind = types.lsp.CompletionItemKind[b:get_kind()]
      --   print(a_kind, b_kind)

      --     return true
      --   end
      --   return false
      -- end,
      -- function(a, b)
      --   -- print(vim.inspect(a.completion_item))
      --   return true
      -- end,
      -- compare.order,
      -- compare.locality,
      -- compare.recently_used,
      -- compare.sort_text,
    },
  },
  mapping = {
    ["<tab>"] = cmp.mapping({
      s = tab,
      i = tab,
      c = function()
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      end,
    }),
    ["<s-tab>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        elseif can_jump(-1) then
          jump(-1)
        else
          fallback()
        end
      end,
      c = function()
        cmp.select_prev_item({ behaviour = cmp.SelectBehavior.Insert })
      end,
    }),
    ["<cr>"] = cmp.mapping(function(fallback)
      if cmp.get_selected_entry() ~= nil then
        cmp.confirm()
      else
        fallback()
      end
    end),
    ["<c-j>"] = cmp.mapping(function(fallback)
      if cmp.core.view.docs_view:visible() then
        cmp.mapping(cmp.scroll_docs(4))
      elseif can_jump(1) then
        jump(1)
      else
        fallback()
      end
    end),
    ["<c-k>"] = cmp.mapping(function(fallback)
      if cmp.core.view.docs_view:visible() then
        cmp.mapping(cmp.scroll_docs(-4))
      elseif can_jump(-1) then
        jump(-1)
      else
        fallback()
      end
    end),
    ["<up>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end),
    ["<down>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end),
  },
  sources = {
    -- { name = "copilot" },
    {
      name = "nvim_lsp",
      entry_filter = function(entry, ctx)
        local kind = types.lsp.CompletionItemKind[entry:get_kind()]

        if kind == "Keyword" then
          return false
        elseif kind == "Text" then
          return false
        end
        return true
      end,
    },
    { name = "dap" },
    { name = "git" },
    -- { name = "commit" },
    { name = "buffer" },
    { name = "path" },
  },
})

cmp.setup.cmdline("?", {
  -- view = {
  --   entries = "wildmenu"
  -- },
  sources = cmp.config.sources({
    {
      { name = "buffer", max_item_count = 10 },
    },
    {
      { name = "nvim_lsp_document_symbol", max_item_count = 10 },
    },
  }),
})

cmp.setup.cmdline("/", {
  -- view = {
  --   entries = "wildmenu"
  -- },
  sources = cmp.config.sources({
    {
      { name = "buffer", max_item_count = 10 },
    },
    {
      { name = "nvim_lsp_document_symbol", max_item_count = 10 },
    },
  }),
})

cmp.setup.cmdline(":", {
  -- view = {
  --   entries = "wildmenu"
  -- },
  sources = cmp.config.sources({
    { name = "path", max_item_count = 7 },
    { name = "cmdline", max_item_count = 15 },
  }),
})
