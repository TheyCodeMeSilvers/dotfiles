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
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
    },
  },
}
