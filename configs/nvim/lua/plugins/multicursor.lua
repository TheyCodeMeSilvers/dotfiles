return {
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_maps = {
        ['Find Under']         = '<D-d>',
        ['Find Subword Under'] = '<D-d>',
        ['Add Cursor Down']    = '<M-C-Down>',  -- free up <C-Down>
        ['Add Cursor Up']      = '<M-C-Up>',    -- free up <C-Up>
      }
    end,
  },
}
