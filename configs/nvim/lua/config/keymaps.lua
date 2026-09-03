-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local function get_current_file_path()
  local file_path = vim.api.nvim_buf_get_name(0)

  if file_path == "" then
    vim.notify("Current buffer has no file", vim.log.levels.WARN)
    return nil
  end

  return vim.fn.fnamemodify(file_path, ":p")
end

local function copy_to_pasteboard(text, message)
  local result = vim.system({ "pbcopy" }, { stdin = text }):wait()

  if result.code ~= 0 then
    local stderr = vim.trim(result.stderr or "")
    vim.notify(stderr ~= "" and stderr or "pbcopy failed", vim.log.levels.ERROR)
    return
  end

  vim.notify(message)
end

local function fold_all_functions()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)

  if not ok then
    vim.notify("Tree-sitter parser not available for this buffer", vim.log.levels.WARN)
    return
  end

  local function_nodes = {
    arrow_function = true,
    func_literal = true,
    function_declaration = true,
    function_definition = true,
    function_expression = true,
    function_item = true,
    function_statement = true,
    generator_function = true,
    generator_function_declaration = true,
    local_function = true,
    method_declaration = true,
    method_definition = true,
  }
  local fold_ranges = {}
  local seen_ranges = {}

  local function collect_function_folds(node)
    local node_type = node:type()

    if function_nodes[node_type] then
      local start_row, _, end_row = node:range()

      if end_row > start_row then
        local key = string.format("%d:%d", start_row, end_row)

        if not seen_ranges[key] then
          seen_ranges[key] = true
          table.insert(fold_ranges, { start_row + 1, end_row + 1 })
        end
      end
    end

    for child in node:iter_children() do
      collect_function_folds(child)
    end
  end

  for _, tree in ipairs(parser:parse()) do
    collect_function_folds(tree:root())
  end

  if #fold_ranges == 0 then
    vim.notify("No functions found to fold", vim.log.levels.INFO)
    return
  end

  table.sort(fold_ranges, function(left, right)
    if left[1] == right[1] then
      return left[2] > right[2]
    end

    return left[1] < right[1]
  end)

  vim.opt_local.foldmethod = "manual"
  vim.opt_local.foldenable = true
  vim.cmd("silent! normal! zE")

  for _, range in ipairs(fold_ranges) do
    vim.cmd(string.format("%d,%dfold", range[1], range[2]))
  end

  vim.cmd("silent! normal! zM")
  vim.notify(string.format("Folded %d functions", #fold_ranges))
end

map("n", "<leader>fc", function()
  local file_path = get_current_file_path()

  if not file_path then
    return
  end

  copy_to_pasteboard(vim.fn.fnamemodify(file_path, ":h"), "Copied file directory")
end, { desc = "Copy File Directory" })

map("n", "<leader>fo", function()
  local file_path = get_current_file_path()

  if not file_path then
    return
  end

  local result = vim.system({ "open", "-R", file_path }):wait()

  if result.code ~= 0 then
    local stderr = vim.trim(result.stderr or "")
    vim.notify(stderr ~= "" and stderr or "open -R failed", vim.log.levels.ERROR)
    return
  end
end, { desc = "Reveal File In Finder" })

map("n", "<leader>fC", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")

  if vim.bo.endofline and #lines > 0 then
    text = text .. "\n"
  end

  copy_to_pasteboard(text, "Copied file contents")
end, { desc = "Copy File Contents" })

map("n", "<leader>ff", fold_all_functions, { desc = "Fold Functions" })

local function trigger_completion()
  if vim.api.nvim_get_mode().mode ~= "i" then
    vim.cmd("startinsert")
  end

  vim.schedule(function()
    require("blink.cmp").show()
  end)
end

-- Cmd+.: trigger autocomplete suggestions
map({ "n", "i" }, "<D-.>", trigger_completion, { desc = "Trigger completion" })
map({ "n", "i" }, "<D-k>", trigger_completion, { desc = "Trigger completion" })

-- Ghostty fallback for Cmd+. (mapped to F22 in ~/.config/ghostty/config)
map({ "n", "i" }, "<F22>", function()
  if vim.api.nvim_get_mode().mode ~= "i" then
    vim.cmd("startinsert")
  end
  vim.schedule(function()
    require("blink.cmp").show()
  end)
end, { desc = "Trigger completion (Ghostty Cmd+.)" })

-- Fallback manual completion (useful if Cmd+. is intercepted)
map("i", "<C-Space>", function()
  require("blink.cmp").show()
end, { desc = "Trigger completion" })
map("i", "<A-.>", function()
  require("blink.cmp").show()
end, { desc = "Trigger completion" })
map("n", "<A-.>", function()
  vim.cmd("startinsert")
  vim.schedule(function()
    require("blink.cmp").show()
  end)
end, { desc = "Trigger completion" })

-- Cmd+': code actions
map({ "n", "i", "v" }, "<D-'>", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Cmd+L: code actions / quick fix (matching Zed's Cmd+L behavior)
map({ "n", "i", "v" }, "<D-l>", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Cmd+G: go to definition (matching Zed's Cmd+G behavior)
map({ "n", "i", "v" }, "<D-g>", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Cmd+J: hover documentation (function params, types, etc)
map({ "n", "i", "v" }, "<D-j>", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Cmd+S: save current file
map({ "n", "i", "v" }, "<D-s>", function()
  if vim.api.nvim_get_mode().mode ~= "n" then
    vim.cmd("stopinsert")
  end
  vim.cmd("write")
end, { desc = "Save file" })

map("n", "<D-z>", "u", { desc = "Undo" })
map("i", "<D-z>", "<C-o>u", { desc = "Undo" })
map("v", "<D-z>", "<Esc>u", { desc = "Undo" })

map("n", "<D-Z>", "<C-r>", { desc = "Redo" })
map("i", "<D-Z>", "<C-o><C-r>", { desc = "Redo" })
map("v", "<D-Z>", "<Esc><C-r>", { desc = "Redo" })

map("n", "<D-e>", "<leader>e", { remap = true, desc = "Focus Explorer" })
map("i", "<D-e>", "<Esc><leader>e", { remap = true, desc = "Focus Explorer" })
map("v", "<D-e>", "<Esc><leader>e", { remap = true, desc = "Focus Explorer" })

map({ "n", "v" }, "<D-Left>", "0", { desc = "Line start" })
map({ "n", "v" }, "<D-Right>", "$", { desc = "Line end" })
map("i", "<D-Left>", "<C-o>0", { desc = "Line start" })
map("i", "<D-Right>", "<End>", { desc = "Line end" })

map({ "n", "v" }, "<A-Left>", "b", { desc = "Previous word" })
map({ "n", "v" }, "<A-Right>", "w", { desc = "Next word" })
map("i", "<A-Left>", "<C-o>b", { desc = "Previous word" })
map("i", "<A-Right>", "<C-o>w", { desc = "Next word" })
map({ "n", "v" }, "<Esc>[1;3D", "b", { desc = "Previous word" })
map({ "n", "v" }, "<Esc>[1;3C", "w", { desc = "Next word" })
map("i", "<Esc>[1;3D", "<C-o>b", { desc = "Previous word" })
map("i", "<Esc>[1;3C", "<C-o>w", { desc = "Next word" })

map("i", "<D-BS>", "<C-u>", { desc = "Delete to line start" })
map("c", "<D-BS>", "<C-u>", { desc = "Delete to line start" })
map("n", "<D-BS>", "d0", { desc = "Delete to line start" })

map("i", "<A-BS>", "<C-w>", { desc = "Delete previous word" })
map("c", "<A-BS>", "<C-w>", { desc = "Delete previous word" })
map("n", "<A-BS>", "db", { desc = "Delete previous word" })

map("n", "G", "Gzz", { desc = "Goto line centered" })
map("n", "gg", "ggzz", { desc = "Goto first line centered" })
map("n", "g+", ":+", { desc = "Goto relative line forward" })
map("n", "g-", ":-", { desc = "Goto relative line backward" })
map("n", "<C-Down>", "}zz", { desc = "Next paragraph centered" })
map("n", "<C-Up>", "{zz", { desc = "Previous paragraph centered" })

-- Shift+Up/Down: highlight/select text (like Zed)
map("n", "<S-Up>", "v<Up>", { desc = "Select previous line" })
map("n", "<S-Down>", "v<Down>", { desc = "Select next line" })
map("v", "<S-Up>", "<Up>", { desc = "Extend selection up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend selection down" })
map("i", "<S-Up>", "<Esc>v<Up>", { desc = "Select previous line" })
map("i", "<S-Down>", "<Esc>v<Down>", { desc = "Select next line" })

-- Shift+Left/Right: highlight/select text horizontally (like Zed)
map("n", "<S-Left>", "v<Left>", { desc = "Select previous character" })
map("n", "<S-Right>", "v<Right>", { desc = "Select next character" })
map("v", "<S-Left>", "<Left>", { desc = "Extend selection left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend selection right" })

-- Alt+Up/Down: move line (or visual selection) up/down
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Selection Up" })

-- Alt+Shift+Up/Down: duplicate line (or selection) above/below
map("n", "<A-S-Down>", "yyp", { desc = "Duplicate Line Below" })
map("n", "<A-S-Up>", "yyP", { desc = "Duplicate Line Above" })
map("v", "<A-S-Down>", "y'>p", { desc = "Duplicate Selection Below" })
map("v", "<A-S-Up>", "y'<P", { desc = "Duplicate Selection Above" })

map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })
map("n", "f", "/", { desc = "Search (like /)" })
map("n", "rr", vim.lsp.buf.rename, { desc = "Rename" })

-- Leader+b+a: delete all buffers (keeping the current window)
map("n", "<leader>ba", function()
  -- skip the current buffer so the window stays open
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end
  vim.notify("Deleted all other buffers")
end, { desc = "Delete All Other Buffers" })

-- Substitute word under cursor across file
map("n", "s", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Substitute word under cursor" })

-- Close current buffer
map("n", "<D-b>", "<cmd>bdelete<cr>", { desc = "Close buffer" })
