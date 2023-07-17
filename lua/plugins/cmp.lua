-- TODO: This plugin spec does too much, most should be extracted into
-- `config/autocompletion`.

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "onsails/lspkind-nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "petertriho/cmp-git" },
    { "Dosx001/cmp-commit" },
    { "ray-x/cmp-treesitter" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
  }
}
