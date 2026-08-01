return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    opts = function(_, opts)
      local c = require('vscode.colors').get_colors()

      opts.style = 'dark'
      opts.transparent = false
      opts.italic_comments = false
      opts.disable_nvimtree_bg = true
      opts.group_overrides = vim.tbl_deep_extend('force', opts.group_overrides or {}, {
        SnacksPickerGitStatusAdded = { fg = c.vscGitAdded },
        SnacksPickerGitStatusModified = { fg = c.vscGitModified },
        SnacksPickerGitStatusDeleted = { fg = c.vscGitDeleted },
        SnacksPickerGitStatusRenamed = { fg = c.vscGitRenamed },
        SnacksPickerGitStatusCopied = { fg = c.vscGitRenamed },
        SnacksPickerGitStatusUntracked = { fg = c.vscGitUntracked },
        SnacksPickerGitStatusIgnored = { fg = c.vscGitIgnored },
        SnacksPickerGitStatusStaged = { fg = c.vscGitStageModified },
        SnacksPickerGitStatusUnmerged = { fg = c.vscGitConflicting },
      })
    end,
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'vscode',
    },
  },
}
