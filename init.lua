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

require("lazy").setup({
  {
    "abecodes/tabout.nvim",
    config = true,
    after = { "nvim-cmp" },
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
    config = true,
  },
  { "mickael-menu/zk-nvim", config = true },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = true,
  },
  {
    "sindrets/winshift.nvim",
    init = function()
      vim.keymap.set("n", "<leader>wk", "<cmd>WinShift up<cr>")
      vim.keymap.set("n", "<leader>wj", "<cmd>WinShift down<cr>")
      vim.keymap.set("n", "<leader>wh", "<cmd>WinShift left<cr>")
      vim.keymap.set("n", "<leader>wl", "<cmd>WinShift right<cr>")
    end,
    config = true,
  },
  { "chomosuke/term-edit.nvim", config = true, lazy = false },
  { "willothy/flatten.nvim", config = true, lazy = false },
  { "jose-elias-alvarez/null-ls.nvim", config = true },
  { "atusy/tsnode-marker.nvim", config = true },
  { "NeoGitOrg/neogit", config = true },
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
    config = true,
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    init = function()
      vim.keymap.set("n", "<leader>na", require("ts-node-action").node_action, {
        desc = "Trigger Node Action",
      })
    end,
    config = true,
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
    config = true,
  },
  {
    "jonatan-branting/other.nvim",
    dev = true,
    init = function()
      vim.keymap.set("n", "<leader>r", "<cmd>:Other<CR>", {
        silent = true,
        desc = "Open Other",
      })
    end,
    config = true,
  },
  {
    "lambdalisue/fern.vim",
    init = function()
      vim.keymap.set("n", "<leader>o", function()
        return "<cmd>Fern . -reveal=%<cr>"
      end, {
        expr = true,
        desc = "Open File Explorer",
      })
    end,
    config = true,
  },
  { "chaoren/vim-wordmotion" },
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = true,
  },
  { "wiliamboman/mason-lspconfig.nvim", config = true },
  { "nvim-lua/plenary.nvim" },
  { "catppuccin/nvim", lazy = false },
  { "smjonas/inc-rename.nvim", config = true },
  { "jonatan-branting/nvim-better-n", lazy = false, config = true },
  { "echasnovski/mini.nvim", config = true },
  { "folke/neodev.nvim", config = true },
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
    config = true,
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
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = true,
  },
  { "yioneko/nvim-yati", dependencies = { "yioneko/vim-tmindent" } },
  { "MunifTanjim/nui.nvim" },
  { "stevearc/dressing.nvim", config = true },
  { "kylechui/nvim-surround", config = true },
  { "andymass/vim-matchup", config = true },
  { "danymat/neogen", config = true },
  { "famiu/bufdelete.nvim" },
  { "rhysd/conflict-marker.vim" },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "VimEnter",
    lazy = false,
  },
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VimEnter" },
  { "folke/lsp-colors.nvim" },
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
    config = true,
  },
  { "nvim-lua/lsp-status.nvim" },
  { "https://gitlab.com/yorickpeterse/nvim-pqf.git", config = true },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-abolish" },
  { "lewis6991/gitsigns.nvim", config = true },
  { "andrewferrier/wrapping.nvim", config = true },
  { "tpope/vim-fugitive" },
  { "ThePrimeagen/git-worktree.nvim", config = true },
  { "tami5/sql.nvim" },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      { "kevinhwang91/promise-async" },
    },
    config = true,
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
  { "windwp/nvim-ts-autotag", config = true },
  { "dkarter/bullets.vim" },
  { "vim-test/vim-test", config = true },
  { "nvim-treesitter/playground" },
}, {
  dev = {
    path = "~/git/",
  },
})
