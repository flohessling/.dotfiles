return {
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            -- "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim",
        },
        opts = {},
    },
    {
        "mason-org/mason.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            packages = {
                -- dockerfile
                "hadolint",
                "dockerfile-language-server",

                -- go
                "gopls",
                "gci",
                "gofumpt",
                "golines",
                "goimports",

                -- html / htmx
                "htmx-lsp",
                "html-lsp",

                -- js/ts
                "vtsls",

                -- json
                "jsonlint",
                "json-lsp",

                -- lua
                "lua-language-server",
                "stylua",

                -- markdown
                "marksman",

                -- php
                "intelephense",
                "twiggy-language-server",
                "twig-cs-fixer",

                -- proto/buf
                "buf",

                -- shell
                "shellcheck",
                "shfmt",

                -- terraform
                "terraform-ls",
                "hclfmt",
                "tflint",

                -- yaml
                "yaml-language-server",
                "yamllint",
                "yamlfix",
            },
        },

        config = function(_, opts)
            require("mason").setup(opts)

            local registry = require("mason-registry")
            registry.refresh(function()
                for _, pkg_name in ipairs(opts.packages) do
                    local pkg = registry.get_package(pkg_name)
                    if not pkg:is_installed() then
                        vim.notify("Installing: " .. pkg_name, vim.log.levels.INFO)
                        pkg:install()
                    end
                end
            end)
        end,
    },
}
