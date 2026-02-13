vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
    format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
    },
    formatters_by_ft = {
        go = { "gci", "golines" },
        hcl = { "hcl" },
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
    },
    formatters = {
        shfmt = {
            prepend_args = { "-i", "2" },
        },
        gci = {
            args = {
                "write",
                "--skip-generated",
                "-s",
                "Standard",
                "-s",
                "Default",
                "-s",
                "Prefix(github.com/shopware)",
                "--skip-vendor",
                "$FILENAME",
            },
        },
        golines = {
            prepend_args = {
                "--base-formatter=gofumpt",
                "--ignore-generated",
            },
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

-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>F", function()
    require("conform").format()
end, { desc = "Format buffer" })
