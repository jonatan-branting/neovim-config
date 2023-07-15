local MC = require("modules.multi-cursors")
local Session = require("modules.multi-cursors.session")
local delete = require("modules.multi-cursors.operators.delete")
local right_motion = require("modules.multi-cursors.motions.right")
local right_text_object = require("modules.multi-cursors.text_objects.right")

local imhooks = require("modules.multi-cursors.hooks.insert_mode")


vim.keymap.set("n", "d", MC.operator(delete), { expr = true , buffer = true})
vim.keymap.set("n", "l", MC.motion(right_motion), { expr = true , buffer = true})
vim.keymap.set("o", "il", MC.operator_pending(right_text_object), { expr = true, buffer = true })

local ns = vim.api.nvim_create_namespace("test")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
ns = vim.api.nvim_create_namespace("test")

MC.setup()

local session = MC.get_session()

local main_c = session:add_cursor(vim.api.nvim_win_get_cursor(0))
session:set_active_cursor(main_c)

imhooks.setup(session)





session:add_cursor({ 2, 1 })
