require("snacks").setup({
    notifier = { enabled = true },
    lazygit = { enabled = true },
    bufdelete = { enabled = true },
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit filter current file" })
vim.keymap.set("n", "<leader>X", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
-- stylua: ignore end
