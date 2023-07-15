vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function(args)
    -- Return unless we have a filed opened already
    if args.file == "*" or args.file ~= "" then
      return
    end

    -- Return unless current directory is a git repository
    if vim.fn.system("git rev-parse --is-inside-work-tree") ~= "true\n" then
      vim.schedule(function()
        -- vim.cmd("Fern .")
      end)
      return
    end

    -- Return unless git repository is dirty
    if vim.fn.system("git diff --stat") == "" then
      vim.schedule(function()
        -- vim.cmd("Fern .")
      end)
      return
    end

    vim.cmd("Neogit kind=replace")
  end,
})
