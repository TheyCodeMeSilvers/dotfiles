-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "if_many",
  },
})

vim.g.omni_sql_no_default_maps = 1
vim.g.db_ui_disable_mappings_sql = 1
vim.g.db_ui_disable_mappings_javascript = 1
