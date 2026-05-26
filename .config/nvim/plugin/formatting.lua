vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
    format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
    },
    formatters_by_ft = {
        go = { "golangci-lint" },
        hcl = { "terragrunt_hclfmt" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        php = { "php_cs_fixer" },
        proto = { "buf" },
        sh = { "shfmt" },
        sql = { "sqlfmt" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        yaml = { "yamlfmt" },
    },
    formatters = {
        shfmt = {
            prepend_args = { "-i", "2" },
        },
        yamlfmt = {
            prepend_args = { "-formatter", "retain_line_breaks=true" },
        },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        -- Skip auto-format for markdown; use <leader>F to format on demand
        if vim.bo[bufnr].filetype == "markdown" then
            return
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
    end,
})

-- keymaps
vim.keymap.set({ "n", "v" }, "<leader>F", function()
    require("conform").format()
end, { desc = "Format buffer" })
