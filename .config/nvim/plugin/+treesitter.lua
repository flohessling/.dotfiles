-- templ filetype
vim.filetype.add({ extension = { templ = "templ" } })

-- Install parsers
require("nvim-treesitter").install({
    "bash",
    "dockerfile",
    "go",
    "gomod",
    "gowork",
    "gosum",
    "gotmpl",
    "hcl",
    "html",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "nix",
    "php",
    "phpdoc",
    "proto",
    "templ",
    "terraform",
    "yaml",
})

-- Enable treesitter highlighting and indent for all supported filetypes
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- Textobjects: select
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
})

-- stylua: ignore start
local select_to = require("nvim-treesitter-textobjects.select").select_textobject
vim.keymap.set({ "x", "o" }, "aa", function() select_to("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() select_to("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "af", function() select_to("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() select_to("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() select_to("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() select_to("@class.inner", "textobjects") end)

-- Textobjects: move
local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)

-- Textobjects: swap
local swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end)
-- stylua: ignore end

-- Treesitter context (sticky function headers)
require("treesitter-context").setup({})
