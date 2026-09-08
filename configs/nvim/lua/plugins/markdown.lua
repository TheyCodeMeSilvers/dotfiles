return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = false,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
        ["markdown.mdx"] = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        markdown = {},
        ["markdown.mdx"] = {},
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local prev_enabled = opts.enabled

      opts.enabled = function()
        if vim.bo.filetype == "markdown" or vim.bo.filetype == "markdown.mdx" then
          return false
        end

        if type(prev_enabled) == "function" then
          return prev_enabled()
        end

        if prev_enabled == nil then
          return true
        end

        return prev_enabled
      end
    end,
  },
}
