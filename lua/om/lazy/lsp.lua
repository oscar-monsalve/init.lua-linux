return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "j-hui/fidget.nvim",
    },

    config = function()
        vim.filetype.add({
            extension = {
                ino = "arduino",
            },
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("luasnip.loaders.from_vscode").lazy_load()
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "pylsp",
                "clangd",
                "marksman",
                'texlab',
                "zls",
                "lua_ls",
                'bashls',
                "foam_ls",
                -- "rust_analyzer"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "4",
                                    }
                                },
                            }
                        }
                    }
                end,
            }
        })

        vim.lsp.config("arduino_language_server", {
            capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
                textDocument = { semanticTokens = vim.NIL },
                workspace = { semanticTokens = vim.NIL },
            }),
            root_dir = function(bufnr, on_dir)
                local path = vim.api.nvim_buf_get_name(bufnr)
                if path ~= "" and vim.uv.fs_stat(path) then
                    on_dir(vim.fs.dirname(path))
                end
            end,
            workspace_required = true,
            cmd = {
                vim.fn.exepath("arduino-language-server"),
                "-clangd", vim.fn.exepath("clangd"),
                "-cli", vim.fn.exepath("arduino-cli"),
                "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
                -- "-fqbn", "arduino:avr:mega",  -- Comment or uncomment depending on the board
                "-fqbn", "esp32:esp32:esp32", -- Comment or uncomment depending on the board
            },
        })
        vim.lsp.enable("arduino_language_server")

        vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("ArduinoLsp", { clear = true }),
            pattern = "*.ino",
            callback = function(event)
                if #vim.lsp.get_clients({ bufnr = event.buf, name = "arduino_language_server" }) == 0 then
                    local bufnr = event.buf
                    vim.schedule(function()
                        if not vim.api.nvim_buf_is_valid(bufnr) then
                            return
                        end

                        local config = vim.deepcopy(vim.lsp.config.arduino_language_server)
                        config.root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
                        vim.lsp.start(config, { bufnr = bufnr })
                    end)
                end
            end,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),

                completion = cmp.config.window.bordered({
                    border = 'rounded', -- Easier to see than 'single'
                    -- winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
                }),
                documentation = cmp.config.window.bordered({
                    border = 'rounded',
                }),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })


    end
}
