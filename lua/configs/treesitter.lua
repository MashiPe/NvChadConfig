local options = {
    ensure_installed = {
        "bash",
        "fish",
        "lua",
        "luadoc",
        "markdown",
        "printf",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "c",
        "cmake",
        "cpp",
        "make",
        "python",
        "angular",
        "scss",
        "typescript",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)

-- Automatically enable Angular for .component.html and .container.html files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.component.html", "*.container.html" },
    callback = function()
        vim.treesitter.start(nil, "angular")
    end,
})
