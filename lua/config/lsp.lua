local lsp_config = require("lspconfig")
require("lspkind").init()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- Leave reflowing text to vim.
    -- This is used by `gqq`, and if the LSP doesn't properly support it this
    -- just breaks, which can be very annoying.
    vim.bo[args.buf].formatexpr = nil
  end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = nil })

local capabilities =
  require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- leave formatting and diagnostics to null-ls
capabilities.textDocument.formatting = false
capabilities.textDocument.publishDiagnostics = false
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, silent = true })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, silent = true })
  vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { buffer = bufnr, silent = true })

  if client.server_capabilities.signatureHelpProvider then
    require("modules.lsp_signature").setup(client)
  end

  require("better-n").register_keys()
end

local servers = {
  "cssls",
  "solargraph",
  "html",
  "vuels",
  "tsserver",
}

require("mason-lspconfig").setup({
  ensure_installed = servers,
})

for _, server in ipairs(servers) do
  lsp_config[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

require("rust-tools").setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
})

lsp_config.vuels.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    config = {
      vetur = {
        ignoreProjectWarning = true,
      },
    },
  },
})

lsp_config.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      completion = {
        callSnippet = "Disable",
      },
    },
  },
})
