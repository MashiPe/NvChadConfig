require("nvchad.configs.lspconfig").defaults()
local lspconfig = require("lspconfig")

local servers = { "html", "cssls", "pyright", "lua_ls", "clangd", "debugpy" }
vim.lsp.enable(servers)

local nvlsp = require("nvchad.configs.lspconfig")

-- list of servers configured with default config.
local default_servers = { "html", "cssls", "pyright", "gopls"}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup({
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    })
end

lspconfig.lua_ls.setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
})

lspconfig.ts_ls.setup({
    init_options = {
        plugins = {
            {
                name = "@angular/language-server",
                location = vim.fn.getcwd() .. "/node_modules/@angular/language-server",
                enableForWorkspaceTypeScriptVersions = false,
            },
        },
    },
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    filetypes = { "typescript", "javascript" },
})

lspconfig.angularls.setup({
    on_attach = function(client, bufnr)
        --HACK: disable angular renaming capability due to duplicate rename popping up
        client.server_capabilities.renameProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
})

lspconfig.tailwindcss.setup({
    {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    },
})

