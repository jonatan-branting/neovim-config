local opt = vim.opt

vim.g.mapleader = " "

DEFAULT_BORDERS = {
  horiz = "━",
  vert = "┃",
  vertright = "┣",
  vertleft = "┫",
  horizdown = "┳",
  horizup = "┻",
  verthoriz = "╋",
}

vim.opt.fillchars = {
  eob = nil,
  fold = nil,
  foldsep = nil,
  foldopen = "",
  foldclose = "",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

group = vim.api.nvim_create_augroup("CoreSettings", {})
vim.api.nvim_create_autocmd({ "WinEnter", "WinNew", "BufWinEnter" }, {
  group = group,
  callback = function(_args)
    vim.schedule(function()
      if not vim.wo.relativenumber then
        vim.opt_local.statuscolumn = ""
        return
      end

      vim.opt_local.statuscolumn = "%=%{v:relnum ? v:relnum : v:lnum} %s%C"
    end)
  end,
})

vim.o.statuscolumn = ""
opt.termguicolors = true
opt.cmdheight = 1

opt.number = true
opt.relativenumber = true

opt.list = true

opt.linebreak = true
opt.breakindent = true
opt.showmode = false
opt.pumblend = 4
opt.splitkeep = "topline"
opt.winblend = 3
opt.updatetime = 2000
opt.shortmess = "filnxtToOFcI"
opt.hidden = true
opt.mouse = "a"
opt.cursorline = true

opt.inccommand = "nosplit"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
vim.opt.smarttab = true

opt.scrolloff = 2
opt.lazyredraw = false

opt.wildignore = "*.swp,*.bak,*.pyc, *.class"
opt.wildmenu = true
opt.wildmode = "full"
opt.showmode = false

opt.cursorline = false
opt.relativenumber = true
opt.number = true

opt.history = 10000
opt.undolevels = 10000

opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
opt.undofile = true
opt.swapfile = false
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.equalalways = true

opt.visualbell = true
opt.errorbells = false

opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

opt.timeoutlen = 500
opt.linebreak = true
opt.autoindent = true
opt.breakindent = true
opt.breakindent = true
opt.splitbelow = true
opt.splitright = true

opt.laststatus = 3

opt.signcolumn = "yes:1"

opt.exrc = true
opt.secure = true
opt.termguicolors = true
opt.wrap = false
opt.breakindent = true
opt.showbreak = "↳  "
opt.clipboard = "unnamedplus"

opt.startofline = true

vim.g.vimsyn_embed = "l" -- Highlight Lua code inside .vim files
