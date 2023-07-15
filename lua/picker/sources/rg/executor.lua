local Job = require("plenary.job")

local producer = require("picker.sources.rg.producer")

local defaults = {
  prompt = nil,
  cwd = vim.loop.cwd(),
  on_stdout = function() end,
}

-- TODO if we move the args building completely out of this we can extract this to be a global jobs_provider/executor
local function build_args(opts)
  opts = vim.tbl_extend("force", defaults, opts or {})

  local args = {
    "--pcre2",
    "--max-count",
    "6",
    "--max-filesize",
    "1M",
    "--max-depth",
    "7",
    "--max-columns",
    "150",
    "--max-columns-preview",
    "--regexp",
  }

  for _, arg in ipairs(producer(opts.prompt)) do
    table.insert(args, arg)
  end

  table.insert(args, ".")

  return args
end

return function(opts)
  local args = build_args(opts)

  print("running rg",
    vim.inspect({
      prompt = opts.prompt,
      args = args
    })
  )

  local job = Job:new({
    command = 'rg',
    args = args,
    cwd = opts.cwd,
    on_stdout = opts.on_stdout
  })

  return job
end
