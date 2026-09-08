local opts = { buffer = true, silent = true }

vim.keymap.set("n", "<leader>dbe", "<Plug>(DBUI_ExecuteQuery)", vim.tbl_extend("force", opts, { desc = "DB Execute Query" }))
vim.keymap.set("v", "<leader>dbe", "<Plug>(DBUI_ExecuteQuery)", vim.tbl_extend("force", opts, { desc = "DB Execute Query" }))
vim.keymap.set("n", "<leader>dbp", "<Plug>(DBUI_EditBindParameters)", vim.tbl_extend("force", opts, { desc = "DB Edit Bind Parameters" }))
vim.keymap.set("n", "<leader>dbw", "<Plug>(DBUI_SaveQuery)", vim.tbl_extend("force", opts, { desc = "DB Save Query" }))
