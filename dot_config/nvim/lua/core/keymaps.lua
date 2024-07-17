local M = {}

vim.g.mapleader = " "

local keys = vim.keymap

-- Group naming
keys.set("n", "<leader>c", "", { desc = "Copilot" })
keys.set("n", "<leader>d", "", { desc = "Debugging" })
keys.set("n", "<leader>f", "", { desc = "Find" })
keys.set("n", "z", "", { desc = "fold" })
keys.set("n", "<leader>l", "", { desc = "LSP" })
-- keys.set("n", "g", "", { desc = "Movement:Go" })
keys.set("n", "m", "", { desc = "Marks" })
keys.set("n", "]", "", { desc = "Movement:Next" })
keys.set("n", "[", "", { desc = "Movement:Previous" })
keys.set("n", "<leader>o", "", { desc = "Others" })
keys.set("n", "<leader>p", "", { desc = "Python" })
keys.set("n", "<leader>m", "", { desc = "Python:Molten" })
keys.set("n", "<leader>w", "", { desc = "Session" })
keys.set("n", "<leader>t", "", { desc = "Tabs" })
keys.set("n", "<leader>s", "", { desc = "Windows" })

-- Copilot
keys.set("n", "<leader>cc", ":CopilotChat<CR>", { desc = "Open copilot chat" })
keys.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = "Enable copilot completions" })
keys.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = "Disable copilot completions" })

-- Debugger
keys.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", { desc = "Debug: Toggle debugging UI" })
keys.set("n", "<leader>dr", ":lua require('dapui').open({ reset = true })<CR>", { desc = "Debug: Reset UI" })
keys.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
keys.set("n", "<leader>d5", ":DapContinue<CR>", { desc = "Debug: Resume program" })
keys.set("n", "<leader>d6", ":DapStepOver<CR>", { desc = "Debug: Step over" })
keys.set("n", "<leader>d7", ":DapStepInto<CR>", { desc = "Debug: Step into" })
keys.set("n", "<leader>d8", ":DapStepOut<CR>", { desc = "Debug: Step out" })
keys.set("n", "<leader>dm", ":lua require('neotest').run.run()<cr>", { desc = "Test Method" })
keys.set("n", "<leader>dM", ":lua require('neotest').run.run({strategy = 'dap'})<cr>", { desc = "Test Method DAP" })
keys.set("n", "<leader>df", ":lua require('neotest').run.run({vim.fn.expand('%')})<cr>", { desc = "Test Class" })
keys.set(
  "n",
  "<leader>dF",
  ":lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
  { desc = "Test Class DAP" }
)
keys.set("n", "<leader>dS", ":lua require('neotest').summary.toggle()<cr>", { desc = "Test Summary" })

-- Misc
keys.set("i", "kj", "<Esc>")
keys.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keys.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
keys.set("n", "<C-s>", ":w<CR>", { noremap = true })
keys.set("i", "<C-s>", "<C-o>:write<CR>a", { noremap = true })
keys.set("n", "<leader>g", ":Neogit<CR>")

-- Others
keys.set("n", "<leader>ol", ":lua require('nabla').popup()<CR>", { desc = "Nabla: Popup" })
keys.set("n", "<leader>om", ":MarkdownPreviewToggle<CR>", { desc = "Markdown: Preview" })

-- Python
keys.set("n", "<leader>po", ":PyrightOrganizeImports<CR>", { desc = "Python: Organize imports" })
keys.set(
  "n",
  "<leader>pp",
  ":PyrightSetPythonPath .venv/bin/python<CR>",
  { desc = "Python: Set python path to workdir's .venv" }
)
-- Python:molten
keys.set("n", "<leader>mi", function()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv ~= nil then
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd("MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })
keys.set("n", "<leader>mD", ":MoltenDeinit<CR>", { silent = true, desc = "Molten de-initialize" })
keys.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Run operator selection" })
keys.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })
keys.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-evaluate cell" })
keys.set("n", "<leader>mR", ":MoltenRestart<CR>", { silent = true, desc = "Molten restart" })
keys.set("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Evaluate visual selection" })
keys.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "Molten delete cell" })
keys.set("n", "<leader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Show/enter output" })
keys.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "Hide output" })
keys.set("n", "<leader>m]", ":MoltenNext<CR>", { silent = true, desc = "Go to next cell" })
keys.set("n", "<leader>m[", ":MoltenPrev<CR>", { silent = true, desc = "Go to pref cell" })

-- Find
keys.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keys.set("n", "<leader>fh", ":nohl<CR>", { desc = "Clear search highlights" })
keys.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keys.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keys.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
keys.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

-- Tab management
keys.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keys.set("n", "<leader>tl", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keys.set("n", "L", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keys.set("n", "H", "<cmd>tabp<CR>", { desc = "Go to prev tab" })
keys.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Window management
keys.set("n", "<leader>ss", ":vsplit<CR>", { desc = "Split window vertically" })
keys.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
keys.set("n", "<leader>sv", "<C-w>=", { desc = "Make windows equal size" })
keys.set("n", "<leader>sl", "<cmd>close<CR>", { desc = "Close current split" })

-- LSP
keys.set(
  "n",
  "<leader>lc",
  ":lua require('neogen').generate()<CR>",
  { noremap = true, silent = true, desc = "Generate docstring" }
)
function M.lsp_attach_callback(ev)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf, silent = true }

  opts.desc = "Show documentation for what is under cursor"
  keys.set("n", "<leader>l?", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

  opts.desc = "Go to declaration"
  keys.set("n", "<leader>lT", vim.lsp.buf.declaration, opts) -- go to declaration
  opts.desc = "Show LSP definitions"
  keys.set("n", "<leader>ly", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
  opts.desc = "Show LSP implementations"
  keys.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

  opts.desc = "Smart rename"
  keys.set("n", "<leader>ln", vim.lsp.buf.rename, opts) -- smart rename
  opts.desc = "Show LSP references"
  keys.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
  opts.desc = "Show LSP type definitions"
  keys.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
  opts.desc = "See available code actions"
  keys.set({ "n", "v" }, "<leader>lC", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

  opts.desc = "Show buffer diagnostics"
  keys.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
  opts.desc = "Show line diagnostics"
  keys.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line
  opts.desc = "Go to previous diagnostic"
  keys.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
  opts.desc = "Go to next diagnostic"
  keys.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
  opts.desc = "Restart LSP"
  keys.set("n", "<leader>lR", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
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
