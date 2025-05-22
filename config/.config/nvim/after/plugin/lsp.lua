vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLSPAttach", { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
            { desc = "Go to definition", buffer = opts.buffer })
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
            { desc = "Go to declaration", buffer = opts.buffer })
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end,
            { desc = "Go to implementation", buffer = opts.buffer })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
            { desc = "Show hover information", buffer = opts.buffer })
        -- vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end,
        --     { desc = "Search workspace symbols", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>vwa", function() vim.lsp.buf.add_workspace_folder() end,
            { desc = "Add workspace folder", buffer = opts.buffer })
        -- vim.keymap.set("n", "<leader>ds", function() vim.lsp.buf.document_symbol() end,
        --     { desc = "Search document symbols", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
            { desc = "Show diagnostics", buffer = opts.buffer })
        -- Using trouble for it
        --NOTE:setloclist not viewloclist vim.keymap.set("n", "<leader>co", function() vim.diagnostic.setloclist() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
            { desc = "Go to next diagnostic", buffer = opts.buffer })
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
            { desc = "Go to previous diagnostic", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
            { desc = "Trigger code action", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end,
            { desc = "Show references", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end,
            { desc = "Rename symbol", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>td", function() vim.lsp.buf.type_definition() end,
            { desc = "Go to type definition", buffer = opts.buffer })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            { desc = "Show signature help", buffer = opts.buffer })
        vim.keymap.set("n", "<leader>fd", function() vim.lsp.buf.format { async = true } end,
            { desc = "Format document", buffer = opts.buffer })

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

        -- -- Automatically format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LSPFormatOnSave", { clear = true }),
            buffer = event.buf,                      -- Ensures this applies to the specific buffer
            callback = function()
                vim.lsp.buf.format({ async = true }) -- Runs the format asynchronously
            end,
        })

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set("n", "<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = "Turn on inlay hints", buffer = opts.buffer })
        end
        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
            virtual_text = true
        })


        vim.g.zig_fmt_autosave = 0
        vim.g.zig_fmt_parse_errors = 0

        -- vim.api.nvim_create_autocmd('BufWritePre', {
        --     pattern = { "*.zig", "*.zon" },
        --     callback = function(ev)
        --         vim.lsp.buf.code_action({
        --             context = { only = { "source.organizeImports" } },
        --             apply = true,
        --         })
        --         vim.lsp.buf.code_action({
        --             context = { only = { "source.fixAll" } },
        --             apply = true,
        --         })
        --     end
        -- })
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
    sources = {
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp",               keyword_length = 1 },
        { name = "luasnip" },
        { name = "path" },
        { name = 'buffer' },
    },
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
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { '!' }
            }
        }
    })
})

-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_capabilities = vim.tbl_deep_extend("force", {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities())

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "clangd", "lua_ls", "gopls", "zls" },
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
                        },
                        ui = {
                            diagnostics = {
                                -- Disable diagnostics popup
                                show_diagnostics = false
                            }
                        }
                    }
                }
            })
        end,
        ['zls'] = function()
            require("lspconfig").zls.setup({
                capabilities = lsp_capabilities,
                -- cmd = { "/home/tanz/Documents/software/zls/zig-out/bin/zls" },
                -- settings = {
                --     zls = {
                --         -- enable_build_on_save = true,
                --
                --         zig_exe_path = "/usr/bin/zig",
                --     }
                -- }
            })
        end,
    },
})
