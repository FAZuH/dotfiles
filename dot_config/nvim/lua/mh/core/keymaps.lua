vim.g.mapleader = " "

local keymap = vim.keymap
-- normal mode
keymap.set("i", "kj", "<Esc>")

-- save file with ctrl-s
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<C-o>:write<CR>a", { noremap = true })

-- for clearing highlight on search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights" })

-- J to move the current line down
-- vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "move line down", noremap = true, silent = true })
-- K to move the current line up (use g? to show docs for something)
-- vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "move line up", noremap = true, silent = true })

-- increment or decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "decrement number" })

-- spliting windows
keymap.set("n", "<leader>ss", ":vsplit<CR>", { desc = "split window vertically" })
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "split window horizontally" })
keymap.set("n", "<leader>sv", "<C-w>=", { desc = "make windows equal size" })
keymap.set("n", "<leader>sl", "<cmd>close<CR>", { desc = "close current split" })

-- tab management
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "open new tab" })
keymap.set("n", "<leader>tl", "<cmd>tabclose<CR>", { desc = "close current tab" })
keymap.set("n", "L", "<cmd>tabn<CR>", { desc = "go to next tab" })
keymap.set("n", "H", "<cmd>tabp<CR>", { desc = "go to prev tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })

-- python
keymap.set("n", "<leader>po", ":PyrightOrganizeImports<CR>", { desc = "Python: Organize imports" })
keymap.set(
  "n",
  "<leader>pp",
  ":PyrightSetPythonPath .venv/bin/python<CR>",
  { desc = "Python: Set python path to workdir's .venv" }
)

-- debugger
keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", { desc = "Debug: Toggle debugging UI" })
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "Debug: Resume program" })
keymap.set("n", "<leader>dr", ":lua require('dapui').open({ reset = true })<CR>", { desc = "Debug: Reset UI" })
