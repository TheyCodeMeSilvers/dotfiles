return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        keyword = {
          range = "full",
        },
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
        },
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        preset = "enter",
        ["<CR>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_and_accept({ force = true })
            end
          end,
          "fallback",
        },
      },
    },
  },
}
