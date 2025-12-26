-- [ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Note: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
--

map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggles the file window (nvim-tree)' })

-- c++ specific
local function switch_h_cpp()
  local ext = vim.fn.expand '%:e' -- current file extension

  if ext == 'h' or ext == 'hpp' then
    vim.cmd ':e %:r.cpp'
  elseif ext == 'cpp' then
    vim.cmd ':e %:r.h'
  else
    print 'Not a C++ source/header file'
    return
  end
end

map('n', 'grs', switch_h_cpp, { desc = 'Switch between .cpp and .h (or .hpp) file' })

-- c++ build and run
map('n', 'grb', '<cmd>!cmake --build build<CR>', { desc = 'Build cmake project to folder "build"' })

local function run_exe()
  local cwd = vim.fn.getcwd()
  local cwdContent = vim.split(vim.fn.glob(cwd .. '/build/*.exe'), '\n', { trimempty = true })

  for _, exeFullPath in pairs(cwdContent) do
    local indexOfLastSlash = string.find(exeFullPath, '/[^/]*$')
    -- On Windows check against \ slash instead of /
    if indexOfLastSlash == nil then
      indexOfLastSlash = string.find(exeFullPath, '\\[^\\]*$')
    end

    local exeFileName = string.sub(exeFullPath, indexOfLastSlash + 1, string.len(exeFullPath))
    vim.cmd('!build\\' .. exeFileName)
  end
end
map('n', 'gre', run_exe, { desc = 'Runs exe in "build" folder' })

-- git specific
map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>', { desc = 'Preview git hunk' })
