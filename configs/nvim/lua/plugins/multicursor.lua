return {
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<D-d>',
        ['Find Subword Under'] = '<D-d>',
      }
    end,
  },
}
