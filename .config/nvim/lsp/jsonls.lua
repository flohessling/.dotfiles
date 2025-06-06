return {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.buf_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                end,
            },
        },
    },
}
