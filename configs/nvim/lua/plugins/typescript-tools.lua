return {
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      for _, ft in ipairs({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) do
        opts.formatters_by_ft[ft] = { 'prettier' }
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    optional = true,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      local eslint = opts.servers.eslint or {}

      eslint.root_dir = function(bufnr, on_dir)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local eslint_root = vim.fs.root(filename, { 'eslint.config.js', 'eslint.config.cjs', 'eslint.config.mjs', 'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts', '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml' })

        if not eslint_root then
          return
        end

        if vim.uv.fs_stat(vim.fs.joinpath(eslint_root, 'node_modules', 'eslint')) then
          on_dir(eslint_root)
        end
      end

      eslint.settings = vim.tbl_deep_extend('force', eslint.settings or {}, {
        workingDirectory = { mode = 'auto' },
        format = true,
      })

      opts.servers.eslint = eslint
    end,
  },
}
