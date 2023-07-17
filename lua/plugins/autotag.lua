return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-treesitter.configs").setup({
      autotag = {
        enable = true,
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
      },
    })
  end,
}
