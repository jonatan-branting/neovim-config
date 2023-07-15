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
vim.g.leader = "<space>"

require("lazy").setup(
{
  {
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>', -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          {open = "'", close = "'"},
          {open = '"', close = '"'},
          {open = '`', close = '`'},
          {open = '(', close = ')'},
          {open = '[', close = ']'},
          {open = '{', close = '}'}
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    after = {'nvim-cmp'} -- if a completion plugin is using tabs load it before
  },
  {
    "ThePrimeagen/refactoring.nvim",
    init = function()
      vim.api.nvim_set_keymap(
      "v",
      "<leader>r",
      ":lua require('refactoring').select_refactor()<CR>",
      { noremap = true, silent = true, expr = false }
      )
    end,
    config = function()
      require("refactoring").setup({})
    end,
  },
  {
    "mickael-menu/zk-nvim",
    config = function()
      require("zk").setup({
        -- See Setup section below
      })
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = "Comments" },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      motions = {
        count = true,
      },
      icons = {
        breadcrumb = ">", -- symbol used in the command line area that shows your active key combo
        separator = "=>", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000, -- positive value to position WhichKey above other floating windows.
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
      show_help = true, -- show a help message in the command line for using WhichKey
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specifiy a list manually
      -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
      triggers_nowait = {
        -- marks
        "`",
        "'",
        "g`",
        "g'",
        -- registers
        '"',
        "<c-r>",
        -- spelling
        "z=",
      },
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = { "j", "k" },
        v = { "j", "k" },
      },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by default for Telescope
      disable = {
        buftypes = {},
        filetypes = {},
      },
    }
  },
  {
    "sindrets/winshift.nvim",
    init = function()
      vim.keymap.set("n", "<leader>wk", "<cmd>WinShift up<cr>")
      vim.keymap.set("n", "<leader>wj", "<cmd>WinShift down<cr>")
      vim.keymap.set("n", "<leader>wh", "<cmd>WinShift left<cr>")
      vim.keymap.set("n", "<leader>wl", "<cmd>WinShift right<cr>")
    end,
    config = function()
      require("winshift").setup({
        highlight_moving_win = true,
        focused_hl_group = "Visual",
        moving_win_options = {
          wrap = false,
          cursorline = false,
          cursorcolumn = false,
          colorcolumn = "",
        },
        keymaps = {
          disable_defaults = false,
          win_move_mode = {
            ["h"] = "left",
            ["j"] = "down",
            ["k"] = "up",
            ["l"] = "right",
            ["H"] = "far_left",
            ["J"] = "far_down",
            ["K"] = "far_up",
            ["L"] = "far_right",
            ["<left>"] = "left",
            ["<down>"] = "down",
            ["<up>"] = "up",
            ["<right>"] = "right",
            ["<S-left>"] = "far_left",
            ["<S-down>"] = "far_down",
            ["<S-up>"] = "far_up",
            ["<S-right>"] = "far_right",
          },
        },
        window_picker = function()
          return require("winshift.lib").pick_window({
            picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            filter_rules = {
              cur_win = true,
              floats = true,
              filetype = {},
              buftype = {},
              bufname = {},
            },
            filter_func = function()
            end,
          })
        end,
      })
    end,
  },
  {
    "chomosuke/term-edit.nvim",
    init = function()
      require("term-edit").setup({
        prompt_end = "%› ",
      })
    end,
  },
  {
    "willothy/flatten.nvim",
    init = function()
      require("flatten").setup({
        callbacks = {
          pre_open = function()
            -- Close toggleterm when an external open request is received
            -- require("toggleterm").toggle(0)
          end,
          post_open = function(bufnr, winnr, ft)
            if ft == "gitcommit" then
              -- If the file is a git commit, create one-shot autocmd to delete it on write
              -- If you just want the toggleable terminal integration, ignore this bit and only the
              -- code in the else block
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = function()
                  -- This is a bit of a hack, but if you run bufdelete immediately
                  -- the shell can occasionally freeze
                  vim.defer_fn(function()
                    vim.api.nvim_buf_delete(bufnr, {})
                  end, 100)
                end,
              })
            else
              -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
              -- This gives the appearance of the window opening independently of the terminal
              -- require("toggleterm").toggle(0)
              vim.api.nvim_set_current_win(winnr)
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            -- require("toggleterm").toggle(0)
          end,
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.completion.spell,
          null_ls.builtins.formatting.rubocop,
          null_ls.builtins.diagnostics.rubocop,
        },
      })
    end,
  },
  {
    "atusy/tsnode-marker.nvim",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tsnode-marker-markdown", {}),
        pattern = "markdown",
        callback = function(ctx)
          require("tsnode-marker").set_automark(ctx.buf, {
            target = { "code_fence_content" },
            hl_group = "CursorLine",
          })
        end,
      })
    end,
  },
  {
    "NeoGitOrg/neogit",
    config = function()
      require("neogit").setup({})
    end,
  },
  {
    "RRethy/vim-illuminate",
    init = function()
      vim.keymap.set({ "x", "n" }, "]]", function()
        require("illuminate").goto_next_reference(false)
      end, {
        desc = "Next Reference",
      })

      vim.keymap.set({ "x", "n" }, "[[", function()
        require("illuminate").goto_prev_reference(false)
      end, {
        desc = "Previous Reference",
      })
      vim.keymap.set({ "o", "v" }, "ii", function()
        require("illuminate").textobj_select()
      end, {
        desc = "Previous Reference",
      })
    end,
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "dirvish",
          "fugitive",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
      })
    end,
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    init = function()
      vim.keymap.set(
        { "n" },
        "<leader>na", -- TODO: Maybe register this as a code-action and map leader-n to node actions?
        require("ts-node-action").node_action,
        { desc = "Trigger Node Action" }
      )
    end,
    config = function()
      require("ts-node-action").setup({})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "aaronhallaert/ts-advanced-git-search.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      { "prochri/telescope-all-recent.nvim" },
      { "nvim-telescope/telescope-dap.nvim" },
    },
    init = function()
      local telescope = require("telescope.builtin")

      local themes = require("telescope.themes")
      local get_ivy = function(opts)
        local default_opts = {
          borderchars = {
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
        }
        return themes.get_ivy(vim.tbl_deep_extend("force", default_opts, opts or {}))
      end

      vim.keymap.set("n", "<leader>f", function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end)
      vim.keymap.set("n", "<leader>p", function()
        telescope.find_files(get_ivy())
      end)
      vim.keymap.set("n", "<leader>i", function()
        telescope.find_files(get_ivy({ cwd = vim.fn.expand("%:h") }))
      end)
      vim.keymap.set("n", "<leader>e", function()
        telescope.buffers(get_ivy())
      end)
      vim.keymap.set("n", "<leader>,", function()
        telescope.resume(get_ivy())
      end)
      vim.keymap.set("n", "<leader>m", function()
        telescope.oldfiles(get_ivy())
      end)
      vim.keymap.set("n", "<leader><tab>", function()
        telescope.current_buffer_fuzzy_find(get_ivy())
      end)
      vim.keymap.set("n", "<leader>e", function()
        telescope.buffers(get_ivy())
      end)
      vim.keymap.set("n", "<leader>gwc", function()
        require("telescope").extensions.git_worktree.create_git_worktree(get_ivy())
      end)
      vim.keymap.set("n", "<leader>gwl", function()
        require("telescope").extensions.git_worktree.git_worktrees(get_ivy())
      end)
      vim.keymap.set("n", "gr", function()
        telescope.lsp_references(get_ivy())
      end)
      vim.keymap.set("n", "gd", function()
        telescope.lsp_definitions(get_ivy())
      end)
      vim.keymap.set("n", "gw", function()
        telescope.grep_string(get_ivy())
      end)
    end,
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          borderchars = {
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<c-k>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<cr>"] = actions.select_default,
              ["<c-p>"] = actions.cycle_history_prev,
              ["<c-n>"] = actions.cycle_history_next,
            },
          },
        },
        pickers = {},
        extensions = {
          git_worktree = {
            git_worktrees = {
              theme = "ivy",
            },
            create_worktree = {
              theme = "ivy",
            },
            theme = "ivy",
          },
          git_worktrees = {
            theme = "ivy",
          },
          live_grep_args = {
            theme = "ivy",
          },
        },
      })
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("advanced_git_search")
      require("telescope").load_extension("git_worktree")
      require("telescope-all-recent").setup({})
    end,
  },
  {
    "jonatan-branting/other.nvim",
    dev = true,
    init = function()
      vim.keymap.set("n", "<leader>r", "<cmd>:Other<CR>", { silent = true })
    end,
    config = function()
      require("other-nvim").setup({
        mappings = {
          "rails",
          {
            pattern = "/lib/(.*)/(.*).rb$",
            target = "/test/lib/%1/%2_test.rb",
            context = "spec",
          },
          {
            pattern = "/test/lib/(.*)/(.*)_test.rb$",
            target = "/lib/%1/%2.rb",
            context = "spec",
          },
          {
            pattern = "/apps/(.*)/(.*).rb$",
            target = "/test/apps/%1/%2_test.rb",
            context = "spec",
          },
          {
            pattern = "/test/apps/(.*)/(.*)_test.rb$",
            target = "/apps/%1/%2.rb",
            context = "spec",
          },
          {
            pattern = "/lua/tests/(.*)/(.*)_spec.lua$",
            target = "/lua/%1/%2.lua",
            context = "spec",
          },
          {
            pattern = "/lua/(.*)/(.*).lua$",
            target = "/lua/tests/%1/%2_spec.lua",
            context = "spec",
          },
        },
        style = {
          border = "single",
          seperator = "|",
          width = 0.7,
          minHeight = 2,
        },
        rememberBuffers = false,
      })
    end,
  },
  {
    "lambdalisue/fern.vim",
    init = function()
      vim.keymap.set("n", "<leader>o", function()
        return "<cmd>Fern . -reveal=%<cr>"
      end, { expr = true })
    end,
    config = function()
      vim.g["fern#hide_cursor"] = 1
      vim.g["fern#keepjumps_on_edit"] = 0
      vim.g["fern#keepalt_on_edit"] = 1
    end,
  },
  { "chaoren/vim-wordmotion" },
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "catppuccin/nvim",
    lazy = false,
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "jonatan-branting/nvim-better-n",
    init = function()
      require("better-n").setup({
        callbacks = {
          mapping_executed = function(_, key)
            if key == "n" then
              return
            end

            -- Clear highlighting, indicating that `n` will not goto the next
            -- highlighted search-term
            vim.cmd([[ nohl ]])
          end,
        },
        mappings = {
          ["]h"] = { previous = "[h", next = "]h" },
          ["[h"] = { previous = "[h", next = "]h" },

          ["]m"] = { previous = "[m", next = "]m" },
          ["[m"] = { previous = "[m", next = "]m" },

          ["]r"] = { previous = "[r", next = "]r" },
          ["[r"] = { previous = "[r", next = "]r" },

          ["]a"] = { previous = "[a", next = "]a" },
          ["[a"] = { previous = "[a", next = "]a" },

          ["]f"] = { previous = "[f", next = "]f" },
          ["[f"] = { previous = "[f", next = "]f" },

          ["]n"] = { previous = "[n", next = "]n" },
          ["[n"] = { previous = "[n", next = "]n" },

          ["]d"] = { previous = "[d", next = "]d" },
          ["[d"] = { previous = "[d", next = "]d" },

          ["]q"] = { previous = "[q", next = "]q" },
          ["[q"] = { previous = "[q", next = "]q" },

          ["]b"] = { previous = "[b", next = "]b" },
          ["[b"] = { previous = "[b", next = "]b" },

          ["]c"] = { previous = "[c", next = "]c" },
          ["[c"] = { previous = "[c", next = "]c" },

          -- Why does this not work? :o
          ["]]"] = { previous = "[[", next = "]]" },
          ["[["] = { previous = "[[", next = "]]" },

          ["<leader>hn"] = { previous = "<leader>hp", next = "<leader>hn" },
          ["<leader>hp"] = { previous = "<leader>hp", next = "<leader>hn" },

          ["<leader>bn"] = { previous = "<leader>bp", next = "<leader>bn" },
          ["<leader>bp"] = { previous = "<leader>bp", next = "<leader>bn" },

          ["<leader>un"] = { previous = "<leader>up", next = "<leader>un" },
          ["<leader>up"] = { previous = "<leader>up", next = "<leader>un" },
        },
      })
    end,
  },
  {
    "nvim-neorg/neorg",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
        },
      })
    end,
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("modules.mini")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
        setup_jsonls = true,
        lspconfig = true,
        debug = false,
        experimental = {
          pathStrict = true,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    init = function()
      local suggestion = require("copilot.suggestion")

      -- TODO: Make this work, otherwise normal-mode <c-e> is non-functional
      -- if suggestion.is_visible() then
      -- vim.keymap.set("i", "<c-e>", function()
      --   suggestion.accept()
      -- else
      --   return "<c-o>g$"
      -- end
      -- end, { expr = true })

      vim.keymap.set("i", "<c-p>", function()
        suggestion.prev()
      end)

      vim.keymap.set("i", "<c-n>", function()
        suggestion.next()
      end)
    end,
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          panel = {
            enabled = false,
          },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept_line = "<c-e>",
              accept = "<c-y>",
              next = "<c-n>",
              prev = "<c-p>",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            norg = false,
            svn = false,
            cvs = false,
            ruby = true,
            ["."] = false,
          },
          copilot_node_command = vim.fn.expand("$HOME") .. "/.local/share/nvm/v16.17.1/bin/node",
          plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
          server_opts_overrides = {
            advanced = {
              length = 1,
            },
          },
        })
      end, 100)
    end,
  },
  { "mrjones2014/smart-splits.nvim" },
  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
    init = function()
      vim.g.ruby_indent_assignment_style = "variable"
      vim.g.ruby_indent_hanging_elements = true
      vim.g.ruby_indent_block_style = "do"
      vim.g.ruby_indent_access_modifier_style = "indent"
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-neotest/neotest-plenary" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-vim-test" },
      { "zidhuss/neotest-minitest" },
      { "haydenmeade/neotest-jest" },
      { "olimorris/neotest-rspec" },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function(args)
          vim.keymap.set("n", "<leader>tn", function()
            require("neotest").run.run()
          end, { buffer = args.buf })
          vim.keymap.set("n", "<leader>tf", function()
            require("neotest").run.run(vim.fn.expand("%"))
          end, { buffer = args.buf })
        end,
      })
    end,
    config = function()
      require("modules.neotest")
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({
        window = {
          blend = 100,
          relative = "editor",
        },
        fmt = {
          stack_upwards = false,
        },
      })
    end,
  },
  {
    "yioneko/nvim-yati",
    dependencies = { "yioneko/vim-tmindent" }
  },
  { "MunifTanjim/nui.nvim" },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "m",
          normal_cur = "mm",
          normal_line = "M",
          visual = "m",
          delete = "md",
          change = "mc",
        },
      })
    end,
  },
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({})
    end,
  },
  { "famiu/bufdelete.nvim" },
  {
    "rhysd/conflict-marker.vim",
    config = function()
      -- TODO !!!
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "VimEnter",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("modules.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VimEnter",
  },
  { "folke/lsp-colors.nvim" },
  { "rafamadriz/friendly-snippets" },
  { "honza/vim-snippets" },
  { "neovim/nvim-lspconfig" },
  { "simrat39/rust-tools.nvim" },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "onsails/lspkind-nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "rcarriga/cmp-dap" },
      { "petertriho/cmp-git" },
      { "Dosx001/cmp-commit" },
      { "ray-x/cmp-treesitter" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      require("modules.cmp")
    end,
  },
  { "nvim-lua/lsp-status.nvim" },
  {
    "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    config = function()
      require("pqf").setup()
    end,
  },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-abolish" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("modules.gitsigns")
    end,
  },
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup()
    end,
  },
  { "tpope/vim-fugitive" },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      local worktree = require("git-worktree")
      worktree.setup({
        update_on_change = true,
        clearjumps_on_change = true,
      })

      vim.api.nvim_create_user_command("GW", function(opts)
        local branch_name = opts.args

        require("git-worktree").create_worktree(branch_name, "develop", "origin")
      end, { nargs = 1 })
    end,
  },
  { "tami5/sql.nvim" },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      { "kevinhwang91/promise-async" },
    },
    config = function()
      require("modules.bqf")
    end,
  },
  { "romainl/vim-qf" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "haya14busa/vim-asterisk" },
  { "junegunn/vim-easy-align" },
  { "tpope/vim-repeat" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-sleuth" },
  { "rebelot/heirline.nvim" },
  { "tpope/vim-rsi" },
  { "tpope/vim-commentary" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        enabled = true,
        filetypes = {
          "html",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "eruby",
          "erb",
        },
      })
    end,
  },
  { "dkarter/bullets.vim" },
  {
    "vim-test/vim-test",
    config = function()
      local term_integrations = require("modules.term.integrations")

      term_integrations.set_vim_test_strategy()
    end,
  },
  {
    "jonatan-branting/nvim-dap",
    keys = {},
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text" },
    },
    init = function()
      require("modules.dap")

      local dap = require("dap")
      vim.keymap.set("n", "<leader>ds", dap.stop)
      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>dk", dap.up)
      vim.keymap.set("n", "<leader>dj", dap.down)
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>d-", dap.run_last)
      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open({}, "vsplit")
      end)
      vim.keymap.set("n", "<leader>de", function()
        dap.set_exception_breakpoints({ "all" })
      end)
    end,
  },
  { "nvim-treesitter/playground" },
},
{
  dev = {
    path = "~/git/",
  }
}
)

F = F or {}
function F.iter_buffer_range(buffer, range, func, opts)
  return require("utils").iter_buffer_range(buffer, range, func, opts)
end

require("modules.core_settings")
require("modules.colorscheme")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- config?
    require("modules._lsp")
    require("modules.mappings")
    require("modules.diagnostics")

    -- TODO: todo plugin
    require("modules._todo")

    -- TODO: popup plugin
    require("modules.popup").setup()

    require("modules.ui.heirline")

    -- TODO: mouse hover plugin
    require("modules.mouse_hover").setup()
    require("modules.on_mouse_hover.focus_window")
    require("modules.on_mouse_hover.show_diagnostics")

    -- TODO: term plugin
    require("modules.term").setup()
    vim.keymap.set("n", "<leader>l", function()
      require("modules.term"):get_terminal():toggle()
    end)
    vim.keymap.set({ "n", "x" }, "<leader>x", function()
      -- TODO we can likely expand this to language specific mappings, which might wrap things
      -- to auto-monkey-patch stuff in Ruby, for example, by using Treesitter

      require("modules.term")
        :get_terminal()
        :send(vim.fn.getline("."))
    end)
    vim.keymap.set("n", "<leader>l", function()
      require("modules.term")
        :get_terminal()
        :toggle()
    end)
  end,
})

local group = vim.api.nvim_create_augroup("AutoReload", {})

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

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = group,
  callback = function(args)
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
  end,
})

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
