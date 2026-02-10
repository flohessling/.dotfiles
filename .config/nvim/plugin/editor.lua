-- ==========================================================================
-- Harpoon
-- ==========================================================================
-- stylua: ignore start
vim.keymap.set("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Toggle Harpoon menu" })
vim.keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end, { desc = "Navigate to Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end, { desc = "Navigate to Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end, { desc = "Navigate to Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end, { desc = "Navigate to Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end, { desc = "Navigate to Harpoon file 5" })
-- stylua: ignore end

-- ==========================================================================
-- git-blame
-- ==========================================================================
vim.g.gitblame_enabled = 0

vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gbo", ":GitBlameOpenCommitURL<CR>", { desc = "Git blame open commit URL" })

-- ==========================================================================
-- Undotree
-- ==========================================================================
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })

-- ==========================================================================
-- visual-whitespace
-- ==========================================================================
require("visual-whitespace").setup()

-- ==========================================================================
-- todo-comments
-- ==========================================================================
require("todo-comments").setup()

-- ==========================================================================
-- Gitsigns
-- ==========================================================================
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
})

vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git preview hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
