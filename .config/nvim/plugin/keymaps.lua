vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- disable recording & ex mode
vim.keymap.set("", "q", "<nop>")
vim.keymap.set("", "Q", "<nop>")

-- : to ;
vim.keymap.set("n", ";", ":", { noremap = true })

-- remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- center page on find/scroll
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- treat ctrl-c as ESC
vim.keymap.set("i", "<C-c>", "<Esc>")

-- clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")
vim.keymap.set({ "i", "n" }, "<C-c>", "<cmd>noh<cr><C-c>")

-- add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- paste without copying the selected content
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without copying the selected content" })

-- diagnostic keymaps
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic in float" })

-- toggle wrap
vim.keymap.set("n", "<leader>ww", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
