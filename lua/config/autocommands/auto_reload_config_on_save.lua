local reload = require("plenary.reload")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~/git/dotfiles/config/nvim/") .. "**/*.lua",
  group = group,
  callback = function(args)
    if vim.endswith(args.file, "_spec.lua") then
      return
    end

    if args.file:match("nvim/init.lua") then
      return
    end

    reload.reload_module(args.file)
    vim.cmd.luafile(args.file)
    vim.schedule(function()
      print("reloaded:", args.file)
    end)
  end,
})
