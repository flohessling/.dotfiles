require("lint").linters_by_ft = {
    dockerfile = { "hadolint" },
    go = { "golangcilint" },
    json = { "jsonlint" },
    nix = { "nix" },
    php = { "php", "phpstan" },
    proto = { "buf_lint" },
    sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
        require("lint").try_lint()
    end,
})
