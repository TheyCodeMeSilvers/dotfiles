-- SQL language server (sqlls) via LazyVim's nvim-lspconfig integration
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqlls = false,
      },
    },
  },
}
