-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("config.keymaps").lsp_attach(client, args.buf)
    end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

vim.cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]])

-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})

-- check if reloading is necessary after file changes
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- close some filetypes with <q>
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
        "neotest-output",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- workaround for hover borders
local hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
    return hover({
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.7),
        max_height = math.floor(vim.o.lines * 0.7),
    })
end

-- --- Set root dir
-- local root_names = { '.git', 'Makefile' } -- Array of file names indicating root directory. Modify to your liking.
-- local root_cache = {} -- Cache to use for speed up (at cost of possibly outdated results)
--
-- local set_root = function()
--     -- Get directory path to start search from
--     local path = vim.api.nvim_buf_get_name(0)
--     if path == '' then return end
--     path = vim.fs.dirname(path)
--
--     -- Try cache and resort to searching upward for root directory
--     local root = root_cache[path]
--     if root == nil then
--         local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
--         if root_file == nil then return end
--         root = vim.fs.dirname(root_file)
--         root_cache[path] = root
--     end
--
--     -- Set current directory
--     vim.fn.chdir(root)
-- end
--
-- local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
-- vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })
