-- [[ Enable LSP servers ]]
-- Each server needs a matching config in lsp/<name>.lua
vim.lsp.enable({
    "gopls",
    "intelephense",
    "jsonls",
    "lua_ls",
    "terraform_ls",
    "yaml_ls",
})

-- [[ LSP Keymaps ]]
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
        nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")

        -- stylua: ignore start
        nmap("gd", "<cmd>lua require('fzf-lua').lsp_definitions({jump1 = true})<CR>", "[G]oto [D]efinition")
        nmap("gr", "<cmd>lua require('fzf-lua').lsp_references({jump1 = true, ignore_current_line = true})<CR>", "[G]oto [R]eferences")
        nmap("gI", "<cmd>lua require('fzf-lua').lsp_implementations({jump1 = true})<CR>", "[G]oto [I]mplementation")
        nmap("<leader>D", "<cmd>lua require('fzf-lua').lsp_type_definitions({jump1 = true})<CR>", "Type [D]efinition")
        nmap("<leader>ds", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", "[D]ocument [S]ymbols")
        nmap("<leader>ws", "<cmd>lua require('fzf-lua').lsp_dynamic_workspace_symbols()<CR>", "[W]orkspace [S]ymbols")
        -- stylua: ignore end

        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "Format",
            function(_) vim.lsp.buf.format() end,
            { desc = "Format current buffer with LSP" }
        )
    end,
})

-- [[ Go: organize imports on save ]]
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


