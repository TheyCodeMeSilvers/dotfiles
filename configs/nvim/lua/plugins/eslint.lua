-- Only attach the eslint LSP when an eslint library is actually resolvable.
--
-- The adviser-portal monorepo commits a root `eslint.config.mjs` but has no
-- eslint devDependency at the root, so `node_modules/eslint` never exists
-- there. vscode-eslint would pick the repo root as its root_dir, fail to
-- resolve the library, and emit "Unable to find ESLint library." on startup.
-- Gating on the library keeps eslint working inside packages that do install
-- it (e.g. packages/frontend/factfind) while staying silent elsewhere.

local config_files = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  ".eslintrc",
}

local function has_eslint_library(dir)
  if vim.uv.fs_stat(dir .. "/node_modules/eslint") then
    return true
  end
  for parent in vim.fs.parents(dir) do
    if vim.uv.fs_stat(parent .. "/node_modules/eslint") then
      return true
    end
  end
  return false
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname == "" then
              return
            end

            local found = vim.fs.find(config_files, {
              upward = true,
              path = vim.fs.dirname(fname),
            })[1]
            if not found then
              return
            end

            local dir = vim.fs.dirname(found)
            if not has_eslint_library(dir) then
              return
            end

            on_dir(dir)
          end,
        },
      },
    },
  },
}
