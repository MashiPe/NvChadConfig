require("nvchad.options")

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
vim.opt.relativenumber = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

vim.o.updatetime = 200
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})
