M = {}

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable Recording & Ex Mode
vim.keymap.set("", "q", "<nop>")
vim.keymap.set("", "Q", "<nop>")

-- : to ;
vim.keymap.set("n", ";", ":", { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Center page on find/scroll
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("i", "<C-c>", "<Esc>")

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")
vim.keymap.set({ "i", "n" }, "<C-c>", "<cmd>noh<cr><C-c>")

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Paste without copying the selected content
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without copying the selected content" })

-- Treat ctrl-c as ESC for visual block mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Diagnostic keymaps
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic in float" })

-- toggle wrap
vim.keymap.set("n", "<leader>ww", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })

-- configure LSP related keymaps
M.lsp_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>lr", vim.lsp.buf.rename, "[LSP] Rename")
    nmap("<leader>la", vim.lsp.buf.code_action, "[LSP] Code Action")

    nmap("gd", "<cmd>lua require('fzf-lua').lsp_definitions({jump_to_single_result = true})<CR>", "[G]oto [D]efinition")
    nmap(
        "gr",
        "<cmd>lua require('fzf-lua').lsp_references({jump_to_single_result = true, ignore_current_line = true})<CR>",
        "[G]oto [R]eferences"
    )
    nmap(
        "gI",
        "<cmd>lua require('fzf-lua').lsp_implementations({jump_to_single_result = true})<CR>",
        "[G]oto [I]mplementation"
    )
    nmap(
        "<leader>D",
        "<cmd>lua require('fzf-lua').lsp_type_definitions({jump_to_single_result = true})<CR>",
        "Type [D]efinition"
    )
    nmap("<leader>ds", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", "[D]ocument [S]ymbols")
    nmap("<leader>ws", "<cmd>lua require('fzf-lua').lsp_dynamic_workspace_symbols()<CR>", "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

return M
