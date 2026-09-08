return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "jutonz/neotest-bun",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.adapters = opts.adapters or {}

      local bun_adapter = require("neotest-bun")()
      local build_spec = bun_adapter.build_spec

      bun_adapter.build_spec = function(args)
        local spec = build_spec(args)

        if spec and not spec.cwd then
          spec.cwd = bun_adapter.root(args.tree:data().path)
        end

        return spec
      end

      table.insert(opts.adapters, bun_adapter)

      return opts
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test (Neotest)" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Open Test Output (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary (Neotest)" },
    },
  },
}
