-- TODO this causes crashes with ml_get!
local conditions = require("heirline.conditions")
local h_utils = require("heirline.utils")
local ui_utils = require("lib.colors")
local utils = require("utils")

local function setup_colors()
  local colors = {
    bg = ui_utils.get_highlight("Statusline").bg,
    fg = ui_utils.get_highlight("Statusline").fg,

    red = ui_utils.get_highlight("DiagnosticError").fg,
    green = ui_utils.get_highlight("String").fg,
    blue = ui_utils.get_highlight("Function").fg,
    gray = ui_utils.get_highlight("NonText").fg,
    orange = ui_utils.get_highlight("Constant").fg,
    purple = ui_utils.get_highlight("Statement").fg,
    cyan = ui_utils.get_highlight("Special").fg,

    diag_warn = ui_utils.get_highlight("DiagnosticWarn").fg,
    diag_error = ui_utils.get_highlight("DiagnosticError").fg,
    diag_hint = ui_utils.get_highlight("DiagnosticHint").fg,
    diag_info = ui_utils.get_highlight("DiagnosticInfo").fg,

    git_del = ui_utils.get_highlight("DiffDelete").fg,
    git_add = ui_utils.get_highlight("DiffAdd").fg,
    git_change = ui_utils.get_highlight("DiffChange").fg,
  }

  local variations = {}

  for k, v in pairs(colors) do
    variations["bright_" .. k] = ui_utils.brighten(v, 0.25)
    variations["faded_" .. k] = ui_utils.darken(v, 0.75)
    variations["dark_" .. k] = ui_utils.darken(v, 0.75)
  end

  colors = utils.merge(colors, variations)
  return colors
end

require("heirline").load_colors(setup_colors())

local column_component = {
  provider = function(self)
    local padding = ""
    for _ = 1, #tostring(vim.fn.line("$")) - #tostring(vim.fn.col(".")) do
      padding = padding .. " "
    end
    if #padding == 0 then padding = " " end
    return padding .. vim.fn.col(".") .. " "
  end,
  hl = function(self)
    local color = self:mode_color()
    return { bg = color, fg = "bg", bold = true }
  end,
  update = 'CursorMoved',
}

local filename_component = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)

    self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
    if self.lfilename == "" then
      self.lfilename = "[No Name]"
    end
    if not conditions.width_percent_below(#self.lfilename, 0.27) then
      self.lfilename = vim.fn.pathshorten(self.lfilename)
    end
  end,
  {
    flexible = 2,
    {
      provider = function(self)
        return self.lfilename
      end,
    }, {
      provider = function(self)
        return vim.fn.pathshorten(self.lfilename)
      end,
    }
  },
}

local file_flags = {
  {
    provider = function()
      if vim.bo.modified then
        return "_"
      end
    end,
    hl = { fg = "green" },
  },
  {
    provider = function()
      if not vim.bo.modifiable or vim.bo.readonly then
        return "^"
      end
    end,
    -- hl = "Constant",
  },
}

local filename_separator_left = {
  provider = function()
    if conditions.is_active() then return  "››" else return "‹‹" end
  end
}

local filename_separator_right = {
  provider = function()
    if conditions.is_active() then return "‹‹" else return "››" end
  end
}

local filename_block =
  {
    filename_separator_left,
    filename_component,
    filename_separator_right,
    unpack(file_flags)
  }

local file_type = {
  provider = function()
    return string.lower(vim.bo.filetype)
  end,
  hl = "Type",
}

local file_encoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

local file_format = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and fmt:upper()
  end,
}

local file_size = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize <= 0 then
      return "0" .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
  end,
}

local file_last_modified = {
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date("%c", ftime)
  end,
}

local lsp_component = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  -- Or complicate things a bit and get the servers names
  provider  = function(self)
    local names = {}
    for i, server in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return table.concat(names, " ") or "no lsp attached"
  end,
  hl = {},
}

local diagnostics_component = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },
  -- on_click = {
  --   -- callback = function()
  --   --   require("trouble").toggle({ mode = "document_diagnostics" })
  --   -- end,
  --   -- name = "heirline_diagnostics",
  -- },

  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = "DiagnosticError",
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = "DiagnosticWarn",
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = "DiagnosticInfo",
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = "DiagnosticHint",
  },
}

local git_component = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    self.cwd = vim.fn.getcwd():gsub('^.*/', '')
  end,

  -- on_click = {
  --   callback = function(self, minwid, nclicks, button)
  --     -- vim.defer_fn(function()
  --     --   vim.cmd("Lazygit %:p:h")
  --     -- end, 100)
  --   end,
  --   name = "heirline_git",
  --   update = false,
  -- },
  hl = { fg = "bg", bg = "fg", bold = true },
  {
    provider = function(self)

      if not self.status_dict then return ' ' .. self.cwd end


      local head = self.status_dict.head

      local max_head_len = 20
      if string.len(head) > max_head_len then
        head = head:sub(1, max_head_len - 3) .. '...'
      end

      if head and #head > 0 then
        return '  ' .. head .. ' '
      else
        return '  untracked '
      end
    end,
  },
}

local dap_component = {
  condition = function()
    return require("dap").session() ~= nil
  end,
  provider = function()
    --       ﰇ  
    return " " .. require("dap").status()
  end,
  hl = "Debug",
}

local work_dir = {
  provider = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#self.cwd, 0.27) then
      self.cwd = vim.fn.pathshorten(self.cwd)
    end
  end,
  hl = { italic = true },
  -- on_click = {
  --   callback = function()
  --     vim.cmd('NvimTreeToggle')
  --   end,
  --   name = "heirline_workdir",
  -- },

  {
    flexible = 1,
    {
      provider = function(self)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"
        return self.cwd .. trail .. " "
      end,
    }, {
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"
        return cwd .. trail .. " "
      end,
    }, {
      provider = "",
    }
  },
}

local help_filename = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = "Directory",
}

local aligner = { provider = "%=" }
local spacer = { provider = " " }

local default_statusline = {
  column_component,
  spacer,
  lsp_component,
  spacer,
  diagnostics_component,
  aligner,
  dap_component,
  aligner,
  spacer,
  work_dir,
  git_component,
}

local inactive_statusline = {
  condition = function()
    return not conditions.is_active()
  end,
  { hl = { fg = "gray", force = true }, work_dir },
  filename_block,
  { provider = "%<" },
  aligner,
}

local special_statusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,
  h_utils.surround({ " ", "" }, "bright_bg", { file_type }),
  { provider = "%q" },
  spacer,
  help_filename,
  aligner,
}

local git_statusline = {
  condition = function()
    return conditions.buffer_matches({
      filetype = { "^git.*", "fugitive" },
    })
  end,
  file_type,
  spacer,
  {
    provider = function()
      return vim.fn.FugitiveStatusline()
    end,
  },
  spacer,
  aligner,
}

local terminal_statusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,
  { condition = conditions.is_active, column_component, spacer },
  file_type,
  spacer,
  aligner,
}

local statuslines = {
  -- Hack to make sure that floating windows do not update the statusline
  fallthrough = false,
  condition = function (self)
    if utils.is_floating(0) then
      self.winnr = self.last_winnr or self.winnr
    else
      self.last_winnr = self.winnr
    end

    return true
  end,
  hl = function()
    if conditions.is_active() then
      return { fg = "bright_fg", bg = "bright_bg" }
      -- return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  static = {
    mode_colors = {
      n = "green",
      i = "orange",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "green",
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or "n"
      return self.mode_colors[mode]
    end,
  },

  git_statusline,
  special_statusline,
  terminal_statusline,
  inactive_statusline,
  default_statusline,
}

local winbar = {
  hl = function()
    local bg = ui_utils.get_highlight("WinSeparator").fg
    local fg = ui_utils.get_highlight("NormalNC").fg
    return { bg = bg, fg = fg}
  end,
  {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
        filetype = { "^git.*", "fugitive" },
      })
    end,
    init = function()
      vim.opt_local.winbar = nil
    end,
  },
  {
    { provider = " " },
    filename_component,
    unpack(file_flags),
    { provider = " " },
  }
}

require("heirline").setup({
  statusline = statuslines,
  winbar = winbar,
})

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "HeirlineInitWinbar",
  callback = function(args)
    local buf = args.buf
    local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
    local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
    if buftype or filetype then
      vim.opt_local.winbar = nil
    end
  end,
  group = "Heirline",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    require("heirline").reset_highlights()
    require("heirline").load_colors(setup_colors())
    require("heirline").statusline:broadcast(function(self)
      self._win_stl = nil
    end)
  end,
  group = "Heirline",
})
