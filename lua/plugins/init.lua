return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        opts = require("configs.conform"),
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" }, -- uncomment for format on save
        config = function()
            require("configs.treesitter")
        end,
        -- opts = {
        --     ensure_installed = {
        --         "vim",
        --         "lua",
        --         "vimdoc",
        --         "html",
        --         "css",
        --     },
        -- },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },
    {
        "nvim-java/nvim-java",
        lazy = false,
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            {
                "williamboman/mason.nvim",
                opts = {
                    registries = {
                        "github:nvim-java/mason-registry",
                        "github:mason-org/mason-registry",
                    },
                },
            },
        },
        config = function()
            require("java").setup({})
            require("lspconfig").jdtls.setup({
                on_attach = require("nvchad.configs.lspconfig").on_attach,
                capabilities = require("nvchad.configs.lspconfig").capabilities,
                filetypes = { "java" },
            })
        end,
    },
}
