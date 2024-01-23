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
  {
    "mrjones2014/smart-splits.nvim",
    cond = function()
      return vim.g.neovide == nil
    end
  },
  { "MunifTanjim/nui.nvim" },
  { "stevearc/dressing.nvim", config = true },
  { "famiu/bufdelete.nvim" },
  { "rhysd/conflict-marker.vim" },
  { "RRethy/nvim-treesitter-endwise", event = "VimEnter", lazy = false },
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VimEnter" },
  { "folke/lsp-colors.nvim" },
  { "neovim/nvim-lspconfig" },
  { "nvim-lua/lsp-status.nvim" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-abolish" },
  { "https://gitlab.com/yorickpeterse/nvim-pqf.git", config = true },
  { "andrewferrier/wrapping.nvim", config = true },
  { "tpope/vim-fugitive" },
  { "tami5/sql.nvim" },
  { "romainl/vim-qf" },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require("ts_context_commentstring").setup({})
    end
  },
  { "haya14busa/vim-asterisk" },
  { "junegunn/vim-easy-align" },
  { "tpope/vim-repeat" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-rsi" },
  -- { "tpope/vim-commentary" },
  { "dkarter/bullets.vim" },
  { "nvim-treesitter/playground" },
}
