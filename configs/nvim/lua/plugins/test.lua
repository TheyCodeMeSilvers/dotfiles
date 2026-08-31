return {
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test (Neotest)" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
    },
  },
}