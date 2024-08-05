vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLSPAttach", { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vwa", function() vim.lsp.buf.add_workspace_folder() end, opts)
        vim.keymap.set("n", "<leader>ds", function() vim.lsp.buf.document_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        -- Using trouble for it
        -- vim.keymap.set("n", "<leader>co", function() vim.diagnostic.setloclist() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>td", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set("n", "<leader>cf", function()
            require("conform").format({ bufnr = opts.buf })
        end)

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        --  using outline.nvim plugin for this
        -- if client and client.server_capabilities.documentHighlightProvider then
        --     local highlight_augroup = vim.api.nvim_create_augroup("UserLSPHighlight", { clear = false })
        --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        --         buffer = event.buf,
        --         group = highlight_augroup,
        --         callback = vim.lsp.buf.document_highlight,
        --     })
        --
        --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        --         buffer = event.buf,
        --         group = highlight_augroup,
        --         callback = vim.lsp.buf.clear_references,
        --     })
        -- end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set("n", "<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, opts)
        end
        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
            virtual_text = true
        })
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("UserLSPDetach", { clear = true }),
    callback = function(event)
        vim.lsp.buf.clear_references()
        -- vim.api.nvim_clear_autocmds { group = "UserLSPHighlight", buffer = event.buf }
    end,
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    -- sources = {
    --     { name = "buffer",                 dup = 0 },
    --     { name = "nvim_lsp_signature_help" },
    --     { name = "nvim_lsp",               dup = 0 },
    --     { name = "luasnip",                dup = 0 },
    --     { name = "path",                   dup = 0 },
    -- },
    sources = cmp.config.sources({
        { name = "nvim_lsp",               keyword_length = 1 },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "path" },
        { name = "nvim_lua" }
    }, {
        { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    }),
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "cmdline_history", dup = 0 },
        { name = 'path' },
        { name = "cmdline",         max_item_count = 10, dup = 0 },
    }, {
        -- {
        --     name = 'cmdline',
        --     option = {
        --         ignore_cmds = { 'Man', '!' }
        --     }
        -- }
    })
})

-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_capabilities = vim.tbl_deep_extend("force", {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities())

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "clangd", "lua_ls", "gopls" },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({
                capabilities = lsp_capabilities,
            })
        end,
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT"
                        },
                        completion = {
                            callSnippet = "Replace"
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                            }
                        },
                    }
                }
            })
        end,
        ['gopls'] = function()
            require("lspconfig").gopls.setup({
                capabilities = lsp_capabilities,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        }
                    }
                }
            })
        end
    },
})
