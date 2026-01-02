return {
    {
        "williamboman/mason.nvim",
        tag = "stable",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason.nvim", "nvim-treesitter/nvim-treesitter" },
        config = function()
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
                    -- vim.keymap.set("n", "<leader>fl", function() require("lint").try_lint() end,
                    --     { desc = "Lint document", buffer = opts.buffer })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup = vim.api.nvim_create_augroup("UserLSPHighlight", { clear = false })
                        vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event.buf })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" },
                            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight })
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
                            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references })
                    end

                    if client and client.supports_method("textDocument/formatting") then
                        local format_augroup = vim.api.nvim_create_augroup("UserLSPFormat", { clear = false })
                        vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = event.buf })
                        vim.api.nvim_create_autocmd("BufWritePre",
                            {
                                buffer = event.buf,
                                group = format_augroup,
                                callback = function()
                                    vim.lsp.buf.format({
                                        bufnr =
                                            event.buf,
                                        async = false
                                    })
                                end
                            })
                    end

                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.keymap.set("n", "<leader>th",
                            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                            { desc = "Turn on inlay hints", buffer = opts.buffer })
                    end
                end
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("UserLSPDetach", { clear = true }),
                callback = function(event)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "UserLSPHighlight", buffer = event.buf })
                    vim.api.nvim_clear_autocmds({ group = "UserLSPFormat", buffer = event.buf })
                end
            })

            vim.diagnostic.config({
                update_in_insert = true,
                float = { focusable = false, style = "minimal", border = "rounded", source = true, header = "", prefix = "" },
                virtual_text = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.HINT] = "H",
                        [vim.diagnostic.severity.INFO] = "I",
                    },
                },
            })

            vim.g.zig_fmt_autosave = 0
            vim.g.zig_fmt_parse_errors = 0

            local lsp_capabilities = vim.tbl_deep_extend("force", {},
                vim.lsp.protocol.make_client_capabilities(),
                require('blink.cmp').get_lsp_capabilities())

            vim.lsp.config("gopls", {
                capabilities = lsp_capabilities,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        analyses = {
                            unusedparams = true,
                            unusedwrite = true,
                            nilness = true,
                        },
                        gofumpt = true,
                        semanticTokens = true,
                        staticcheck = true,
                        usePlaceholders = true,
                        completeUnimported = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                    },
                },
            })
            vim.lsp.enable("gopls")

            vim.lsp.config("lua_ls", {
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
                            globals = { "vim", 'require' },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,                        -- Allow Lua workspace to include runtime
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true, -- Support Neovim Lua API
                            },
                        },
                        telemetry = {
                            enable = false,
                        },
                    }
                }
            })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("clangd", {
                capabilities = lsp_capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--header-insertion=iwyu",
                    "--suggest-missing-includes",
                },
                init_options = {
                    clangdFileStatus = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                },
            })
            vim.lsp.enable("clangd")

            vim.lsp.config("zls", {
                capabilities = lsp_capabilities,
                root_markers = { "zls.json", "build.zig", ".git" },
                settings = {
                    zls = {
                        -- Whether to enable build-on-save diagnostics
                        --
                        -- Further information about build-on save:
                        -- https://zigtools.org/zls/guides/build-on-save/
                        enable_build_on_save = true,

                        -- Neovim already provides basic syntax highlighting
                        semantic_tokens = "partial",

                        -- omit the following line if `zig` is in your PATH
                        zig_exe_path = "/sbin/zig",
                        enable = true,
                        diagnostics = {
                            enable = true,
                            severityLevels = { "error", "warning", "info", "hint" },
                        },
                    },
                },
            })
            vim.lsp.enable("zls")

            vim.lsp.config("pyright", {
                capabilities = lsp_capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",    -- Can be "off", "basic", or "strict"
                            diagnosticMode = "workspace",  -- Can be "openFilesOnly" or "workspace"
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true, -- Use library code for type inference
                        },
                    },
                }
            })
            vim.lsp.enable("pyright")

            vim.lsp.config("rust_analyzer", {
                capabilities = lsp_capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true, loadOutDirsFromCheck = true, runBuildScripts = true },
                        procMacro = { enable = true },
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 25 },
                            closureReturnTypeHints = { enable = "with_block" },
                            lifetimeElisionHints = { enable = "skip_trivial" },
                            parameterHints = { enable = true },
                            reborrowHints = { enable = true },
                            typeHints = { enable = true }
                        },
                        diagnostics = { enable = true, experimental = { enable = true } },
                        checkOnSave = { enable = true, command = "clippy" }
                    }
                }
            })
            vim.lsp.enable("rust_analyzer")
        end
    },
    {
        "saghen/blink.cmp",
        -- use a release version when you want prebuilt fuzzy binaries
        version = "*",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "saghen/blink.compat",
                optional = false,
                opts = {},
                version = not vim.g.lazyvim_blink_main and "*",
            },
        },
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            fuzzy = { implementation = "lua" },
            snippets = {
                preset = "default",
            },
            appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
            completion = {
                documentation = { auto_show = true },
                ghost_text = { enabled = false },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                accept = { auto_brackets = { enabled = true } },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        min_keyword_length = 0,
                        async = true,
                    },
                    path = {
                        name = "Path",
                        module = "blink.cmp.sources.path",
                        fallbacks = { "snippets", "buffer" },
                        opts = {
                            trailing_slash = false,
                            label_trailing_slash = true,
                            get_cwd = function(context)
                                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                            end,
                            show_hidden_files_by_default = true,
                        },
                    },
                    buffer = {
                        name = "Buffer",
                        enabled = true,
                        max_items = 100,
                        module = "blink.cmp.sources.buffer",
                        min_keyword_length = 1,
                        opts = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                    },
                    snippets = {
                        name = "snippets",
                        enabled = true,
                        max_items = 15,
                        min_keyword_length = 2,
                        module = "blink.cmp.sources.snippets",
                    },
                },
            },
            keymap = {
                preset = "default",
                ["<C-k>"] = { 'snippet_forward', 'fallback' },
                ["<C-j>"] = { 'snippet_backward', 'fallback' },
            },
            signature = { enabled = true, window = { show_documentation = true } },
            cmdline = {
                enabled = true,
                keymap = { preset = "inherit" },
                sources = { 'path', 'cmdline' },
                completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                        auto_show = function(ctx)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    ghost_text = { enabled = true },
                },
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { { "rafamadriz/friendly-snippets" } },
        run = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            ls.filetype_extend("c", { "cdoc" })
            ls.filetype_extend("cpp", { "cppdoc" })
            vim.keymap.set({ "i" }, "<C-H>", function() ls.expand() end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

            local fmt = require("luasnip.extras.fmt").fmt
            local current_year = os.date("%Y") -- Get the current year
            ls.add_snippets("all", {
                ls.snippet({ trig = "mit", desc = "MIT License" },
                    fmt([[
MIT License

Copyright (C) {year} Anurag Gupta <guptaanurag2106@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
                ]],
                        { year = ls.insert_node(1, current_year) }
                    )
                )
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                notification = { override_vim_notify = false },
            })
        end,
    },
}
