require("om.set")
require("om.remap")
require("om.lazy_init")

local augroup = vim.api.nvim_create_augroup
local omGroup = augroup('omGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

-- Spell checking
autocmd("FileType", {
    pattern = { "markdown", "txt", "env" },
    callback = function(opts)
        local cmp = require("cmp")
        cmp.setup.buffer({ enabled = false })
        -- fixes spanish spell checking
        vim.opt.spelllang = { "en_us" }
        -- vim.opt.spelllang = "es"
        vim.opt.spell = true

        vim.opt.linebreak = true
    end,
})

-- Markview forcibly sets conceallevel=3 via an autocmd.
-- Remove their autocmd and set conceallevel=2
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function()
        -- Remove Markview's conceallevel autocmds
        local ok, ids = pcall(vim.api.nvim_get_autocmds, {
            event = "BufEnter",
            group = "markview",
        })
        if ok and ids then
            for _, id in ipairs(ids) do
                pcall(vim.api.nvim_del_autocmd, id.id)
            end
        end

        -- Force our own conceallevel
        vim.opt_local.conceallevel = 2
    end,
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = omGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = omGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover(vim.tbl_deep_extend("force", {}, { border = "rounded" })) end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help(vim.tbl_deep_extend("force", {}, { border = "rounded" })) end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})
