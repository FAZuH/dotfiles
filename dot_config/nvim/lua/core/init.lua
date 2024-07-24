require("core.options")
require("core.keymaps")

vim.o.laststatus = 0

-- Set line number colors
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#737373", bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#737373", bold = false })

------------
-- Macros --
------------

-- Function to save macros
vim.api.nvim_create_user_command("SaveMacros", function()
  local macros = {}
  for i = 97, 122 do -- ASCII values for 'a' to 'z'
    local macro = vim.fn.getreg(string.char(i))
    if macro ~= "" then
      -- Convert the macro to a list of byte values
      local byte_list = {}
      for j = 1, #macro do
        table.insert(byte_list, string.byte(macro, j))
      end
      macros[string.char(i)] = byte_list
    end
  end
  vim.fn.writefile({ vim.fn.json_encode(macros) }, vim.fn.stdpath("config") .. "/macros.json")
end, {})

-- Function to load macros
vim.api.nvim_create_user_command("LoadMacros", function()
  local macro_file = vim.fn.stdpath("config") .. "/macros.json"
  if vim.fn.filereadable(macro_file) == 1 then
    local content = vim.fn.readfile(macro_file)
    if #content > 0 then
      local macros = vim.fn.json_decode(content[1])
      for reg, byte_list in pairs(macros) do
        -- Convert the list of byte values back to a string
        local macro = string.char(unpack(byte_list))
        vim.fn.setreg(reg, macro)
      end
      print("Macros loaded successfully")
    end
  else
    print("No saved macros found")
  end
end, {})

-- Automatically load macros when Neovim starts
vim.cmd([[autocmd VimEnter * LoadMacros]])
