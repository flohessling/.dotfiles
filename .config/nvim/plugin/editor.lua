-- ==========================================================================
-- Telescope
-- ==========================================================================
local function find_files_from_git_root()
    local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
    end
    local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
    end
    local opts = {}
    if is_git_repo() then
        opts = {
            cwd = get_git_root(),
            hidden = true,
        }
    end
    require("telescope.builtin").find_files(opts)
end

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<C-q>"] = function(prompt_bufnr)
                    require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
                end,
            },
        },
        winblend = 0,

        layout_strategy = "horizontal",
        layout_config = {
            width = 0.95,
            height = 0.85,
            prompt_position = "bottom",

            horizontal = {
                preview_width = function(_, cols, _)
                    if cols > 200 then
                        return math.floor(cols * 0.4)
                    else
                        return math.floor(cols * 0.6)
                    end
                end,
            },

            vertical = {
                width = 0.9,
                height = 0.95,
                preview_height = 0.5,
            },

            flex = {
                horizontal = {
                    preview_width = 0.9,
                },
            },
        },

        selection_strategy = "reset",
        sorting_strategy = "descending",
        scroll_strategy = "cycle",
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
        },
    },

    pickers = {
        lsp_document_symbols = {
            layout_strategy = "horizontal",
            symbol_width = 50,
        },
    },

    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

vim.keymap.set("n", "<C-e>", "<cmd>Telescope oldfiles<CR>", { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader><space>", "<cmd>Telescope buffers<CR>", { desc = "Find existing buffers" })
vim.keymap.set("n", "<leader>f", find_files_from_git_root, { desc = "Search files from git root" })
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "Search files" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<CR>", { desc = "Search current word" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "Search by grep" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<CR>", { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sl", "<cmd>Telescope resume<CR>", { desc = "Search last (resume)" })
vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<CR>", { desc = "Search resume" })

-- ==========================================================================
-- fzf-lua
-- ==========================================================================
require("fzf-lua").setup({
    fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
    },
    defaults = {
        file_icons = "mini",
        formatter = { "path.dirname_first", v = 2 },
    },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        },
    },
    winopts = {
        width = 0.8,
        height = 0.9,
        preview = {
            hidden = "nohidden",
            vertical = "up:45%",
            horizontal = "right:50%",
            layout = "flex",
            flip_columns = 120,
        },
    },
})

vim.keymap.set("n", "<leader>hk", "<cmd>FzfLua keymaps<CR>", { desc = "Search hotkeys" })

-- ==========================================================================
-- Harpoon
-- ==========================================================================
-- stylua: ignore start
vim.keymap.set("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Toggle Harpoon menu" })
vim.keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end, { desc = "Navigate to Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end, { desc = "Navigate to Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end, { desc = "Navigate to Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end, { desc = "Navigate to Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end, { desc = "Navigate to Harpoon file 5" })
-- stylua: ignore end

-- ==========================================================================
-- git-blame
-- ==========================================================================
vim.g.gitblame_enabled = 0

vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gbo", ":GitBlameOpenCommitURL<CR>", { desc = "Git blame open commit URL" })

-- ==========================================================================
-- Undotree
-- ==========================================================================
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })

-- ==========================================================================
-- visual-whitespace
-- ==========================================================================
require("visual-whitespace").setup()

-- ==========================================================================
-- todo-comments
-- ==========================================================================
require("todo-comments").setup()

-- ==========================================================================
-- Gitsigns
-- ==========================================================================
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
})

vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git preview hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
