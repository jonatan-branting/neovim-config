vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("config/nvim/init.lua"),
  group = group,
  callback = function(args)
    -- I want to anyway!
    vim.g.lazy_did_setup = false

    vim.cmd.luafile(args.file)

    vim.schedule(function()
      print("reloaded:", args.file)
    end)
  end,
})
