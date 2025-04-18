return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
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
        end,
        keys = {
            { "<leader>hk", "<cmd>FzfLua keymaps<CR>", { desc = "Search [H]ot[K]eys" } },
            {
                "<leader>P",
                function()
                    local fzf_lua = require("fzf-lua")

                    fzf_lua.fzf_exec(require("project_nvim").get_recent_projects(), {
                        prompt = "projects: ",
                        exec_empty_query = true,
                        fn_transform = function(x)
                            return fzf_lua.utils.ansi_codes.magenta(x)
                        end,
                        actions = {
                            ["default"] = function(selected)
                                fzf_lua.files({ cwd = selected[1] })
                            end,
                        },
                    })
                end,
                { desc = "[S]earch [P]rojects" },
            },
            -- 	{ "<C-e>", "<cmd>FzfLua oldfiles<CR>", { desc = "[?] Find recently opened files" } },
            -- 	{ "<leader><space>", "<cmd>FzfLua buffers<CR>", { desc = "[ ] Find existing buffers" } },
            -- 	{ "<leader>f", "<cmd>FzfLua files<CR>", { desc = "Search [F]iles" } },
            -- 	{ "<leader>sf", "<cmd>FzfLua files<CR>", { desc = "[S]earch [F]iles" } },
            -- 	{ "<leader>sh", "<cmd>FzfLua help_tags<CR>", { desc = "[S]earch [H]elp" } },
            -- 	{ "<leader>sg", "<cmd>FzfLua live_grep<CR>", { desc = "[S]earch by [G]rep" } },
            -- 	{ "<leader>sd", "<cmd>FzfLua diagnostics_document<CR>", { desc = "[S]earch [D]iagnostics" } },
            -- 	{ "<leader>sl", "<cmd>FzfLua resume<CR>", { desc = "[S]earch [L]ast (resume)" } },
            -- 	{ "<leader>sr", "<cmd>FzfLua resume<CR>", { desc = "[S]earch [R]esume" } },
            --
        },
    },
}
