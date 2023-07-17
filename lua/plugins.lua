return {
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
    "lambdalisue/fern.vim",
    init = function()
      vim.g["fern#hide_cursor"] = 1
      vim.g["fern#keepjumps_on_edit"] = 0
      vim.g["fern#keepalt_on_edit"] = 1

      vim.keymap.set("n", "<leader>o", function()
        return "<cmd>Fern . -reveal=%<cr>"
      end, {
        expr = true,
        desc = "Open File Explorer",
      })
    end,
  },
  { "chaoren/vim-wordmotion" },
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = true,
  },
  { "nvim-lua/plenary.nvim" },
  { "catppuccin/nvim", lazy = false },
  { "smjonas/inc-rename.nvim", config = true },
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
    "yioneko/nvim-yati",
    dependencies = { "yioneko/vim-tmindent" },
  },
  { "MunifTanjim/nui.nvim" },
  { "stevearc/dressing.nvim", config = true },
  { "danymat/neogen", config = true },
  { "famiu/bufdelete.nvim" },
  { "rhysd/conflict-marker.vim" },
  { "RRethy/nvim-treesitter-endwise", event = "VimEnter", lazy = false },
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VimEnter" },
  { "folke/lsp-colors.nvim" },
  { "neovim/nvim-lspconfig" },
  { "simrat39/rust-tools.nvim" },
  { "nvim-lua/lsp-status.nvim" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-abolish" },
  { "https://gitlab.com/yorickpeterse/nvim-pqf.git", config = true },
  { "andrewferrier/wrapping.nvim", config = true },
  { "tpope/vim-fugitive" },
  { "tami5/sql.nvim" },
  { "romainl/vim-qf" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "haya14busa/vim-asterisk" },
  { "junegunn/vim-easy-align" },
  { "tpope/vim-repeat" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-rsi" },
  { "tpope/vim-commentary" },
  { "dkarter/bullets.vim" },
  { "nvim-treesitter/playground" },
}
