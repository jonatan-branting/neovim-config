Key = require("lib.key")
Window = require("lib.window")
Buffer = require("lib.buffer")
Enumeratable = require("lib.enumeratable")

vim.opt.shell = "sh"
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=main",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  dev = { path = "~/git/" },
})

require("config")
