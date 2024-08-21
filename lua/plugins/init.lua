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
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        event = "VeryLazy",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function(_, _)
            -- require("configs.dap-mappings").("dap")
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
            require("dap-python").resolve_python = function()
                local current_dir = vim.fn.getcwd()
                local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
                local current_venv = current_dir .. "/venv"
                local parent_venv = parent_dir .. "/venv"
                local python_dir = "/usr"

                if vim.fn.isdirectory(current_venv) ~= 0 then
                    python_dir = current_venv
                end

                if vim.fn.isdirectory(parent_venv) ~= 0 then
                    python_dir = parent_venv
                end

                return python_dir .. "/bin/python"
            end
            -- require("configs.dap-mappings").load_mappings("dap_python")
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    -- Add your default configuration here
                },
                extensions = {
                    file_browser = {
                        -- Define any specific options for file_browser here
                        respect_gitignore = false, -- Example: Whether to respect .gitignore files
                        hidden = true, -- Show hidden files
                    },
                },
            })

            require("telescope").load_extension("file_browser")
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        config = function()
            local HEIGHT_RATIO = 0.8 -- You can change this
            local WIDTH_RATIO = 0.5 -- You can change this too
            require("nvim-tree").setup({
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                            return {
                                border = "rounded",
                                relative = "editor",
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
            })
        end,
    },
}
