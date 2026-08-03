return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>e",
        function()
          local picker = Snacks.picker.get({ source = "explorer" })[1]
          if picker and not picker.closed then
            picker:focus("list")
          else
            Snacks.explorer({ cwd = LazyVim.root() })
          end
        end,
        desc = "Focus Explorer",
      },
    },
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = { "node_modules" },
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = { "node_modules" },
          },
          grep_word = {
            hidden = true,
            ignored = true,
            exclude = { "node_modules" },
          },
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { "node_modules" },
          },
        },
      },
    },
  },
}
