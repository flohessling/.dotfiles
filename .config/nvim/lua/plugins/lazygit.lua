return {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>gg", ":LazyGit<CR>", { desc = "Lazygit" } },
        { "<leader>gf", ":LazyGitFilterCurrentFile<CR>", { desc = "Lazygit Filter Current File" } },
    },
}
