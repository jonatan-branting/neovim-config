require("neodev").setup({
  library = {
    enabled = true,
    runtime = true,
    types = true,
    plugins = true,
  },
  setup_jsonls = true,
  lspconfig = true,
  debug = false,
  experimental = {
    pathStrict = true,
  },
})
