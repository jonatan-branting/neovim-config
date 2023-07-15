vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = group,
  callback = function(args)
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
  end,
})
