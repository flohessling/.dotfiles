vim.lsp.enable("shopware_lsp")

return {
    cmd = { "shopware-lsp" },
    filetypes = { "php", "xml", "twig", "yaml" },
    root_dir = function(bufnr, on_dir)
        local cwd = vim.uv.cwd()
        local buf_path = vim.api.nvim_buf_get_name(bufnr)
        local marker = vim.fs.find({ "composer.json", ".git" }, {
            path = vim.fs.dirname(buf_path),
            upward = true,
        })[1]
        local root = marker and vim.fs.dirname(marker) or cwd

        -- prefer cwd if root is a descendant
        if root:find(cwd, 1, true) == 1 then
            on_dir(cwd)
        else
            on_dir(root)
        end
    end,
}
