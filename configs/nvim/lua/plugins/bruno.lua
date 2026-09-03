return {
  {
    "romek-codes/bruno.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "folke/snacks.nvim",
        opts = { picker = { enabled = true } },
      },
    },
    config = function(_, opts)
      require("bruno").setup(opts)

      local map = LazyVim.safe_keymap_set
      map("n", "<leader>rr", "<cmd>BrunoRun<CR>", { desc = "Bruno: run request" })
      map("n", "<leader>rl", "<cmd>BrunoReplay<CR>", { desc = "Bruno: re-run last request" })
      map("n", "<leader>re", "<cmd>BrunoEnv<CR>", { desc = "Bruno: switch environment" })
      map("n", "<leader>rs", "<cmd>BrunoSearch<CR>", { desc = "Bruno: search requests" })
      map("n", "<leader>rc", "<cmd>BrunoCopy<CR>", { desc = "Bruno: copy as curl" })
      map("n", "<leader>ri", "<cmd>BrunoInspect<CR>", { desc = "Bruno: inspect last request" })
      map("n", "<leader>rt", "<cmd>BrunoToggleView<CR>", { desc = "Bruno: toggle output view" })
    end,
    opts = {
      collection_paths = {
        { name = "web", path = vim.fn.expand("~") .. "/Code/go/web/requests" },
      },
      picker = "snacks",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "http", "lua" } },
  },
}
