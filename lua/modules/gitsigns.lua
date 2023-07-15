require('gitsigns').setup {
  signcolumn = true,
  numhl = false,
  linehl = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = false,
  current_line_blame_opts = {
    delay = 2000,
    virt_text_pos = 'eol'
  },
  sign_priority = 6,
  update_debounce = 100,
  attach_to_untracked = false,
  word_diff = false,
  status_formatter = nil, -- Use default
  -- use_decoration_api = true,
  -- use_internal_diff = true,  -- If luajit is present
  diff_opts = {
    internal = true
  }
}
