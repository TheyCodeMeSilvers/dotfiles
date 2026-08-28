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
            jump = { close = true },
            layout = {
              layout = {
                box = "horizontal",
                width = 90,
                min_width = 90,
                height = 0.8,
                {
                  box = "vertical",
                  border = true,
                  title = "{title} {live} {flags}",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
                { win = "preview", title = "{preview}", border = true, width = 0.5 },
              },
            },
          },
        },
      },
    },
  },
}
