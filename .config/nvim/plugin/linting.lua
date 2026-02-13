local golangcilint = require("lint").linters.golangcilint
golangcilint.args[#golangcilint.args] = function()
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
end

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
