return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.filetype.add({ extension = { templ = "templ" } })
            vim.list_extend(opts.ensure_installed, {
                "go",
                "gomod",
                "gowork",
                "gosum",
                "gotmpl",
                "templ",
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, {
                go = { "gci", "golines" },
                sql = { "sqlfmt" },
            })

            opts.formatters = vim.tbl_deep_extend("force", opts.formatters, {
                gci = {
                    args = { "-s", "-w" },
                    golines = {
                        prepend_args = {
                            "--base-formatter=gofumpt",
                            "--ignore-generated",
                        },
                    },
                },
            })
            -- let gopls run goimports
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    local params = vim.lsp.util.make_range_params(0, "utf-8")
                    params.context = { only = { "source.organizeImports" } }
                    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                    for cid, res in pairs(result or {}) do
                        for _, r in pairs(res.result or {}) do
                            if r.edit then
                                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                        end
                    end
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        opts = function(_, opts)
            opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft, {
                go = { "golangcilint" },
            })
        end,
    },
    -- Testing
    {
        "nvim-neotest/neotest",
        dependencies = {
            {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
                "antoinemadec/FixCursorHold.nvim",
                "fredrikaverpil/neotest-golang",
            },
        },
        opts = {
            adapters = {
                ["neotest-golang"] = {
                    go_test_args = {
                        "-v",
                        "-count=1",
                        "-timeout=60s",
                        "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                    },
                },
            },
        },
    },
}
