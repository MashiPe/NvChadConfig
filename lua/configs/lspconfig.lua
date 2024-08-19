-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "html", "cssls", "pyright", "lua_ls", "clangd" }

local nvlsp = require("nvchad.configs.lspconfig")

-- require("java").setup({})

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    })
end

-- lspconfig.jdtls.setup({
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--     filetypes = { "java" },
-- })

lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
})

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
