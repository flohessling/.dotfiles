-- Advertise cmp capabilities to all LSP servers
vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local cmp = require("cmp")

cmp.setup({
    performance = {
        debounce = 0,
    },
    completion = {
        keyword_length = 1,
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
            local icon, hl = require("mini.icons").get("lsp", item.kind)
            item.kind = icon .. " " .. item.kind
            item.kind_hl_group = hl
            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }
                local is_insert_mode = function()
                    return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
                end
                if is_insert_mode() then -- prevent overwriting brackets
                    confirm_opts.behavior = cmp.ConfirmBehavior.Insert
                end
                if cmp.confirm(confirm_opts) then
                    return -- success, exit early
                end
            end
            fallback() -- if not exited early, always fallback
        end),
    }),
    sources = {
        {
            name = "nvim_lsp",
            entry_filter = function(entry, _)
                return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
        },
        { name = "async_path" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "async_path" },
    }, {
        { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
})
