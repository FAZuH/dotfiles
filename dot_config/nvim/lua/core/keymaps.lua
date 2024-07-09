local M = {}

vim.g.mapleader = " "

local keymap = vim.keymap

-- debugger
keymap.set("n", "<leader>d", "", { desc = "Debugging" })
keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", { desc = "Debug: Toggle debugging UI" })
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
keymap.set("n", "<leader>dr", ":lua require('dapui').open({ reset = true })<CR>", { desc = "Debug: Reset UI" })
keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "Debug: Resume program" })
keymap.set("n", "<leader>ds", ":DapStepOver<CR>", { desc = "Debug: Step over" })
keymap.set("n", "<leader>di", ":DapStepInto<CR>", { desc = "Debug: Step into" })
keymap.set("n", "<leader>do", ":DapStepOut<CR>", { desc = "Debug: Step out" })
keymap.set("n", "<leader>dm", ":lua require('neotest').run.run()<cr>", { desc = "Test Method" })
keymap.set("n", "<leader>dM", ":lua require('neotest').run.run({strategy = 'dap'})<cr>", { desc = "Test Method DAP" })
keymap.set("n", "<leader>df", ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>", { desc = "Test Class" })
keymap.set(
  "n",
  "<leader>dF",
  ":lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
  { desc = "Test Class DAP" }
)
keymap.set("n", "<leader>dS", ":lua require('neotest').summary.toggle()<cr>", { desc = "Test Summary" })

-- misc
keymap.set("i", "kj", "<Esc>")
keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "decrement number" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights" })
keymap.set("n", "<C-s>", ":w<CR>", { noremap = true })
keymap.set("i", "<C-s>", "<C-o>:write<CR>a", { noremap = true })

-- python
keymap.set("n", "<leader>p", "", { desc = "Python" })
keymap.set("n", "<leader>po", ":PyrightOrganizeImports<CR>", { desc = "Python: Organize imports" })
keymap.set(
  "n",
  "<leader>pp",
  ":PyrightSetPythonPath .venv/bin/python<CR>",
  { desc = "Python: Set python path to workdir's .venv" }
)

-- search
keymap.set("n", "<leader>t", "", { desc = "Search & Find" })
keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "fuzzy find files in cwd" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "find string in cwd" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "find string under cursor in cwd" })
keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "find todos" })

-- tab management
keymap.set("n", "<leader>t", "", { desc = "Tabs" })
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "open new tab" })
keymap.set("n", "<leader>tl", "<cmd>tabclose<CR>", { desc = "close current tab" })
keymap.set("n", "L", "<cmd>tabn<CR>", { desc = "go to next tab" })
keymap.set("n", "H", "<cmd>tabp<CR>", { desc = "go to prev tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })

-- window management
keymap.set("n", "<leader>s", "", { desc = "Windows" })
keymap.set("n", "<leader>ss", ":vsplit<CR>", { desc = "split window vertically" })
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "split window horizontally" })
keymap.set("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
keymap.set("n", "<leader>sl", "<cmd>close<CR>", { desc = "close current split" })

-- LSP
function M.lsp_attach_callback(ev)
  keymap.set("n", "<leader>l", "", { desc = "LSP" })
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf, silent = true }
  opts.desc = "show LSP references"
  keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
  opts.desc = "go to declaration"
  keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts) -- go to declaration
  opts.desc = "show LSP definitions"
  keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
  opts.desc = "show LSP implementations"
  keymap.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
  opts.desc = "show LSP type definitions"
  keymap.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
  opts.desc = "see available code actions"
  keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
  opts.desc = "smart rename"
  keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts) -- smart rename
  opts.desc = "show buffer diagnostics"
  keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
  opts.desc = "show line diagnostics"
  keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line
  opts.desc = "go to previous diagnostic"
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
  opts.desc = "go to next diagnostic"
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
  opts.desc = "show documentation for what is under cursor"
  keymap.set("n", "<leader>l?", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
  opts.desc = "restart LSP"
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end

function M.gitsigns_on_attach_callback(bufnr)
  local gitsigns = require("gitsigns")
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gitsigns.nav_hunk("next")
    end
  end, { desc = "Go to next hunk or diff hunk" })

  map("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gitsigns.nav_hunk("prev")
    end
  end, { desc = "Go to previous hunk or diff hunk" })

  -- Actions
  map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
  map("v", "<leader>hs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage selected hunk" })
  map("v", "<leader>hr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset selected hunk" })
  map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
  map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
  map("n", "<leader>hb", function()
    gitsigns.blame_line({ full = true })
  end, { desc = "Blame line" })
  map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
  map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
  map("n", "<leader>hD", function()
    gitsigns.diffthis("~")
  end, { desc = "Diff this (against ~)" })
  map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

return M
