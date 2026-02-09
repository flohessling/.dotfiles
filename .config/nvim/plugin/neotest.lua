-- Neotest diagnostic formatting (compact inline messages)
local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
    virtual_text = {
        format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
        end,
    },
}, neotest_ns)

require("neotest").setup({
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = { enabled = false },
    adapters = {
        require("neotest-golang")({
            go_test_args = {
                "-v",
                "-count=1",
                "-timeout=60s",
                "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
        }),
    },
    icons = {
        expanded = "",
        child_prefix = "",
        child_indent = "",
        final_child_prefix = "",
        non_collapsible = "",
        collapsed = "",
        passed = "",
        running = "",
        failed = "",
        unknown = "",
    },
})

-- nvim-coverage
require("coverage").setup()

-- stylua: ignore start
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run File" })
vim.keymap.set("n", "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, { desc = "Run All Test Files" })
vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run Nearest" })
vim.keymap.set("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Show Output" })
vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle Output Panel" })
vim.keymap.set("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop" })

vim.keymap.set("n", "<leader>tcl", ":Coverage<CR>", { desc = "Test Coverage Load" })
vim.keymap.set("n", "<leader>tcc", ":CoverageClear<CR>", { desc = "Test Coverage Clear" })
vim.keymap.set("n", "<leader>tct", ":CoverageToggle<CR>", { desc = "Test Coverage Toggle" })
vim.keymap.set("n", "<leader>tcs", ":CoverageSummary<CR>", { desc = "Test Coverage Summary" })
-- stylua: ignore end
