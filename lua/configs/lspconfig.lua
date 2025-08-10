local unpack = table.unpack or unpack

require("nvchad.configs.lspconfig").defaults()
local lspconfig = require("lspconfig")

-- local servers = { "html", "cssls", "pyright", "debugpy", "angularls", "tailwindcss" }
-- vim.lsp.enable(servers)

local nvlsp = require("nvchad.configs.lspconfig")

-- list of servers configured with default config.
local default_servers = { "html", "cssls", "pyright", "gopls" }

-- lsps with default config
-- for _, lsp in ipairs(default_servers) do
--     lspconfig[lsp].setup({
--         on_attach = nvlsp.on_attach,
--         on_init = nvlsp.on_init,
--         capabilities = nvlsp.capabilities,
--     })
-- end
vim.lsp.enable(default_servers)

vim.lsp.config("lua_ls", {
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

vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
})
vim.lsp.enable("clangd")

vim.lsp.config("ts_ls", {
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
    root_dir = function(fname)
        local util = require("lspconfig.util")
        local root = util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
        if not root then
            return nil
        end

        local package_json = root .. "/package.json"
        if vim.fn.filereadable(package_json) == 1 then
            local lines = vim.fn.readfile(package_json)
            local content = table.concat(lines, "\n")
            if content:find('"vue"%s*:') then
                return nil -- skip ts_ls for Vue projects
            end
        end
        return root
    end,
})
vim.lsp.enable("ts_ls")

vim.lsp.config("angularls", {
    on_attach = function(client, bufnr)
        --HACK: disable angular renaming capability due to duplicate rename popping up
        client.server_capabilities.renameProvider = false
        nvlsp.on_attach(client, bufnr)
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
})
-- vim.lsp.enable("angularls")

local tailwindcss_language_server_path = vim.fn.expand("$MASON/packages")
    .. "/tailwindcss-language-server/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server"
vim.lsp.config("tailwindcss", {
    {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
        location = tailwindcss_language_server_path,
    },
})
vim.lsp.enable("tailwindcss")

vim.lsp.config("ruby_lsp", {
    on_init = nvlsp.on_init,
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
})
vim.lsp.enable("ruby_lsp")

-- Vuejs config

local vue_language_server_path = vim.fn.expand("$MASON/packages")
    .. "/vue-language-server"
    .. "/node_modules/@vue/language-server"
local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
}
local vtsls_config = {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    on_init = nvlsp.on_init,
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

local vue_ls_config = {
    on_init = function(client, bufnr)
        client.handlers["tsserver/request"] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
            if #clients == 0 then
                vim.notify(
                    "Could not find `vtsls` lsp client, `vue_ls` would not work without it.",
                    vim.log.levels.ERROR
                )
                return
            end
            local ts_client = clients[1]

            local id, command, payload = unpack(result[1])
            ts_client:exec_cmd({
                title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = "typescript.tsserverRequest",
                arguments = {
                    command,
                    payload,
                },
            }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify("tsserver/response", response_data)
            end)
        end

        -- Call original on_init
        if nvlsp.on_init then
            nvlsp.on_init(client, bufnr)
        end
    end,
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
}
-- nvim 0.11 or above
vim.lsp.config("vtsls", vtsls_config)
vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.enable({ "vtsls", "vue_ls" })
