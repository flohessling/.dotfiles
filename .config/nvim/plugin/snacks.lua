require("snacks").setup({
    notifier = { enabled = true },
    lazygit = { enabled = true },
    bufdelete = { enabled = true },
    picker = {
        enabled = true,
        layout = "ivy",
        formatters = {
            file = {
                truncate = 80,
            },
        },
    },
})

-- stylua: ignore start

-- lazygit
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit filter current file" })

-- bufdelete
vim.keymap.set("n", "<leader>X", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })

-- picker: files
vim.keymap.set("n", "<leader>f", function() Snacks.picker.files({ hidden = true }) end, { desc = "Search files from git root" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Search files" })
vim.keymap.set("n", "<C-e>", function() Snacks.picker.recent() end, { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.buffers() end, { desc = "Find existing buffers" })

-- picker: search
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Search by grep" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Search current word" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search help" })
vim.keymap.set("n", "<leader>hk", function() Snacks.picker.keymaps() end, { desc = "Search hotkeys" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.resume() end, { desc = "Search last (resume)" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Search resume" })

-- stylua: ignore end
