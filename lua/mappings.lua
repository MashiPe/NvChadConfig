require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
--
-- General LSP mappings
map("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { desc = "LSP telescope references" })
map("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", { desc = "LSP telescope references" })
map("n", "<C-d>", "<C-d>zz", { desc = "Custom Page Down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Custom Page Up" })
--
-- -- CMP mappings
map("n", "<C-Space>", "<cmd>lua require('cmp').mapping.complete()<CR>", { desc = "Trigger CMP completion" })
--
-- DAP mappings
map("n", "<leader>tbp", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Continue debugging" })
map("n", "<leader>dc", "<cmd>lua require('dapui').close()<CR>", { desc = "Continue debugging" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR><cmd>normal zz<CR>", { desc = "Step over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR><cmd>normal zz<CR>", { desc = "Step into" })
map("n", "<F12>", "<cmd>lua require('dap').step_out()<CR><cmd>normal zz<CR>", { desc = "Step out" })

-- DAP Go mappings
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue debugging for Go" })

-- Gopher mappings
map("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { desc = "Add JSON struct tags" })
map("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { desc = "Add YAML struct tags" })

-- DAP Python mappings
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue debugging for Python" })
