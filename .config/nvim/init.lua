-- [[ Leader ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Options ]]
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 100
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.wrap = false

vim.opt.spelllang:append("cjk")
vim.opt.whichwrap:append("<,>,[,],h,l")

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.list = true
vim.opt.listchars = { tab = "  " }

vim.opt.splitkeep = "cursor"
vim.o.shortmess = "filnxtToOFWIcC"

-- Native floating window borders (replaces dressing.nvim + hover border hacks)
vim.o.winborder = "rounded"

-- [[ Diagnostics ]]
local icons = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = function(diagnostic)
            for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                    return icon
                end
            end
        end,
    },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.INFO] = icons.Info,
            [vim.diagnostic.severity.HINT] = icons.Hint,
        },
    },
})

-- [[ Plugins ]]
vim.pack.add({
    -- Colorscheme & UI
    { src = "https://github.com/flohessling/no-clown-fiesta.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/zbirenbaum/copilot.lua" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },

    -- LSP
    { src = "https://github.com/b0o/schemastore.nvim" },

    -- Completion
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
    { src = "https://codeberg.org/FelipeLema/cmp-async-path" },

    -- Formatting & Linting
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/mfussenegger/nvim-lint" },

    -- Mini
    { src = "https://github.com/echasnovski/mini.nvim" },



    -- Testing
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-neotest/neotest" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/fredrikaverpil/neotest-golang" },
    { src = "https://github.com/andythigpen/nvim-coverage" },

    -- Editor
    { src = "https://github.com/ThePrimeagen/harpoon" },
    { src = "https://github.com/f-person/git-blame.nvim" },
    { src = "https://github.com/tpope/vim-abolish" },
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/mcauley-penney/visual-whitespace.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

}, { load = true })

-- [[ Colorscheme ]]
require("no-clown-fiesta").setup({
    transparent = true,
})
vim.cmd("colorscheme no-clown-fiesta")

-- [[ Lualine ]]
require("lualine").setup({
    options = {
        theme = "auto",
        global_status = true,
        component_separators = "|",
    },
    sections = {
        lualine_c = { { "filename", path = 1 } },
    },
})

-- [[ Copilot ]]
require("copilot").setup({
    panel = { enabled = false },
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<C-y>",
        },
    },
    filetypes = {},
})
