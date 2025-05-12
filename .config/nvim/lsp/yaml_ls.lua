return {
    capabilities = {
        server_compatibilities = {
            documentFormattingProvider = true,
        },
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
    settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
            schemaStore = {
                -- must disable built-in schema store support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- avoide typeError: Cannot read properties of undefined (reading 'schemas')
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
}
