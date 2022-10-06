local autopairs_config = require('configs.autopairs')
local treesitter_config = require('configs.treesister')
local bufferline_config = require('configs.bufferline')
local explorer_config = require('configs.explorer')
local scroll_config = require('configs.scroll')
local lualine_config = require('configs.lualine')
local telescope_config = require('configs.telescope')
local theme_config = require('configs.theme')
local comment_config = require('configs.comment')
local lspsaga_config = require('configs.lspsaga')

return require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer can manage itself

    use {
        'windwp/nvim-autopairs', --------------------- Add support for auto pairs
        requires = {'nvim-treesitter/nvim-treesitter'},
        config = autopairs_config
    }

    use {
        'nvim-treesitter/nvim-treesitter', ------------------ Treesitter for highlight syntax, language compatible
        requires = {
            'windwp/nvim-ts-autotag', ----------------------- Support auto tag for html
            'JoosepAlviste/nvim-ts-context-commentstring', -- Better comment block code
            'p00f/nvim-ts-rainbow' -------------------------- Add rainbow color for code pair
        },
        run = ':TSUpdate',
        config = treesitter_config
    }

    use {
        'm-demare/hlargs.nvim', ----------------------------- Support for highlight function args
        requires = {'nvim-treesitter/nvim-treesitter'}
    }

    use {
        'narutoxy/dim.lua', ------------------------------- Dim unused variable
        requires = {'nvim-treesitter/nvim-treesitter', 'neovim/nvim-lspconfig'}
    }

    use {
        'christoomey/vim-tmux-navigator' ----- Navigtion between screen and tmux using HJKL
    }

    use {
        'neovim/nvim-lspconfig', ------------- Setup built-in LSP
        'williamboman/nvim-lsp-installer' ---- Auto download language server
    }

    use {
        'j-hui/fidget.nvim', ----------------- Add LSP status at bottom-right
        config = function()
            require'fidget'.setup {window = {blend = 0}}
        end
    }

    use {
        'hrsh7th/nvim-cmp', -------------------- UI Completion
        'hrsh7th/cmp-nvim-lsp', ---------------- Nvim LSP binding
        'hrsh7th/cmp-buffer', ------------------ Buffer completion
        'hrsh7th/cmp-path', -------------------- Path Completion
        'onsails/lspkind-nvim', ---------------- Vscode style in completion
        'L3MON4D3/LuaSnip', -------------------- Support snippet for completion
        'saadparwaiz1/cmp_luasnip', ------------ Snippet source
        'hrsh7th/cmp-nvim-lua', ---------------- Completion for Nvim lua API
        'f3fora/cmp-spell', -------------------- Spell suggestion
        'andersevenrud/cmp-tmux', -------------- Completion from tmux content,
        'lukas-reineke/cmp-under-comparator', -- Better completion's sorting
        'hrsh7th/cmp-cmdline', ----------------- Bind completion into vim cmd
        -- 'zbirenbaum/copilot-cmp', -------------- Copilot completion
        run = {'pip3 install black isort flake8 mypy'}
    }

    use {
        'kosayoda/nvim-lightbulb',
        requires = 'antoinemadec/FixCursorHold.nvim',
        config = function()
            require('nvim-lightbulb').setup({autocmd = {enabled = true}})
        end
    }

    -- use {
    --     'zbirenbaum/copilot.lua', -------------- Help auto complete from some case
    --     event = {'VimEnter'},
    --     config = function()
    --         vim.defer_fn(function()
    --             require'copilot'.setup {}
    --         end, 100)
    --     end
    -- }

    use {
        'mattn/emmet-vim', -------------------- Emmet support for NVIM
        config = function()
            vim.g.user_emmet_leader_key = ','
        end
    }

    use {
        'simrat39/rust-tools.nvim', ---------- Rust workplace,
        'alx741/vim-rustfmt', ---------------- Using RustFtm for code formating
        requires = {'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap'}
    }

    use {
        'akinsho/flutter-tools.nvim', -------- Flutter workplace
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require'flutter-tools'.setup {widget_guides = {enabled = true}}
        end
    }

    use {
        'windwp/nvim-spectre',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require'spectre'.setup {}
        end
    }

    use {
        'folke/trouble.nvim', --------------- Lsp warning and error support tool
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'trouble'.setup {}
        end
    }

    use({
        'glepnir/lspsaga.nvim', ------------- Bind extra feature into LSP
        branch = 'main',
        config = lspsaga_config
    })

    use {
        'ray-x/lsp_signature.nvim', ------------------- Function's signature information
        requires = 'williamboman/nvim-lsp-installer',
        config = function()
            require'lsp_signature'.setup {
                bind = true, -- This is mandatory, otherwise border config won't get registered.
                hint_enable = true,
                fix_pos = false,
                auto_close_after = 3,
                floating_window = false,
                handler_opts = {border = 'single'}
            }
        end
    }
    

    use {
        'ray-x/go.nvim',
        require('go').setup({

            disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
            -- settings with {}
            go='go', -- go command, can be go[default] or go1.18beta1
            goimport='gopls', -- goimport command, can be gopls[default] or goimport
            fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
            gofmt = 'gofumpt', --gofmt cmd,
            max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
            tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
            gotests_template = "", -- sets gotests -template parameter (check gotests for details)
            gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
            comment_placeholder = '' ,  -- comment_placeholder your cool placeholder e.g. ﳑ       
            icons = {breakpoint = '', currentpos = ''},  -- setup to `false` to disable icons setup
            verbose = false,  -- output loginf in messages
            lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
                             -- false: do nothing
                             -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
                             --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
            lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
            lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
                                 --      when lsp_cfg is true
                                 -- if lsp_on_attach is a function: use this function as on_attach function for gopls
            lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
            lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
            -- function(bufnr)
            --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
            -- end
            -- to setup a table of codelens
            lsp_diag_hdlr = true, -- hook lsp diag handler
            lsp_diag_underline = true,
            -- virtual text setup
            lsp_diag_virtual_text = { space = 0, prefix = "" },
            lsp_diag_signs = true,
            lsp_diag_update_in_insert = false,
            lsp_document_formatting = true,
            -- set to true: use gopls to format
            -- false if you want to use other formatter tool(e.g. efm, nulls)
           lsp_inlay_hints = {
              enable = true,
              -- Only show inlay hints for the current line
              only_current_line = false,
              -- Event which triggers a refersh of the inlay hints.
              -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
              -- not that this may cause higher CPU usage.
              -- This option is only respected when only_current_line and
              -- autoSetHints both are true.
              only_current_line_autocmd = "CursorHold",
              -- whether to show variable name before type hints with the inlay hints or not
              -- default: false
              show_variable_name = true,
              -- prefix for parameter hints
              parameter_hints_prefix = " ",
              show_parameter_hints = true,
              -- prefix for all the other hints (type, chaining)
              other_hints_prefix = "=> ",
              -- whether to align to the lenght of the longest line in the file
              max_len_align = false,
              -- padding from the left if max_len_align is true
              max_len_align_padding = 1,
              -- whether to align to the extreme right or not
              right_align = false,
              -- padding from the right if right_align is true
              right_align_padding = 6,
              -- The color of the hints
              highlight = "Comment",
            },
            gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
            gopls_remote_auto = true, -- add -remote=auto to gopls
            gocoverage_sign = "",
            sign_priority = 5, -- change to a higher number to override other signs
            dap_debug = true, -- set to false to disable dap
            dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
                                     -- false: do not use keymap in go/dap.lua.  you must define your own.
                                     -- windows: use visual studio keymap
            dap_debug_gui = true, -- set to true to enable dap gui, highly recommend
            dap_debug_vt = true, -- set to true to enable dap virtual text
            build_tags = "tag1,tag2", -- set default build tags
            textobjects = true, -- enable default text jobects through treesittter-text-objects
            test_runner = 'go', -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
            verbose_tests = true, -- set to add verbose flag to tests
            run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
                                     -- float term recommend if you use richgo/ginkgo with terminal color
          
            trouble = false, -- true: use trouble to open quickfix
            test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
            luasnip = true, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
            --  Do not enable this if you already added the path, that will duplicate the entries
          })
    }   

    use {
        'nvim-telescope/telescope.nvim', -------------- File search, text search, buffer search...
        requires = {{'nvim-lua/plenary.nvim'}},
        config = telescope_config
    }

    use {
        'nvim-telescope/telescope-ui-select.nvim', ------ Code action for telescope
        requires = {'nvim-telescope/telescope.nvim'}
    }

    use {
        'prettier/vim-prettier', -------------------------- Code formatter for common language
        run = 'npm i && npm i prettier-plugin-solidity'
    }

    use {
        'kyazdani42/nvim-tree.lua', ----------------------- File Explorer
        requires = {
            'kyazdani42/nvim-web-devicons' ---------------- Support icons
        },
        config = explorer_config
    }

    use 'kyoz/ezbuf.vim' ---------------------------------- Fast delete buffer LeaderBX and LeaderBS
    use 'mg979/vim-visual-multi' -------------------------- Multiple cursor with Ctrl-N

    use {
        'numToStr/Comment.nvim', -------------------------- Better comment block of codes
        requires = 'JoosepAlviste/nvim-ts-context-commentstring',
        config = comment_config
    }

    use 'davidosomething/vim-colors-meh'
    use {
        -- 'projekt0n/github-nvim-theme', -------------------- Github theme
        'kvrohit/rasmus.nvim',
        requires = {'ray-x/lsp_signature.nvim'},
        config = theme_config
    }

    use {
        'rrethy/vim-hexokinase', ------------------------- Color review tool
        run = 'make hexokinase'
    }

    use {
        'akinsho/bufferline.nvim', ----------------------- Buffer tabs
        config = bufferline_config
    }

    use {
        'SmiteshP/nvim-gps', ----------------------------- Current line location in LSP for lualine
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require'nvim-gps'.setup {}
        end
    }

    use {
        'nvim-lualine/lualine.nvim', ---------------------- Bottom line status
        requires = {
            {'kyazdani42/nvim-web-devicons', opt = true}, 'ray-x/lsp_signature.nvim',
            'SmiteshP/nvim-gps'
        },
        config = lualine_config
    }

    use {
        'karb94/neoscroll.nvim', ------------------------- Smooth scrolling support
        config = scroll_config
    }

    use {
        'booperlv/nvim-gomove', ------------------------- Support for moving block code
        config = function()
            require('gomove').setup {}
        end
    }

    use {
        'petertriho/nvim-scrollbar', -------------------- Add scrollbar in file
        config = function()
            require('scrollbar').setup {}
        end
    }

    use {
        'andweeb/presence.nvim', ----------------------- Support for Discord status
        config = function()
            require('presence'):setup{}
        end
    }

    use {
        'lewis6991/gitsigns.nvim', --------------------- Add git info into buffer, AKA gitlens in vscode
        config = function()
            require('gitsigns').setup {current_line_blame = true}
        end
    }

    use {
        'lukas-reineke/indent-blankline.nvim', --------- Better space and tab visual
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append 'space:⋅'
            require('indent_blankline').setup {
                space_char_blankline = ' ',
                show_current_context = true,
                show_current_context_start = true
            }
        end
    }

    use {
        'phaazon/hop.nvim', ---------------------------- Jump around buffer with go word(gw) and go line(gl)
        branch = 'v1',
        config = function()
            require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
        end
    }

    use {
        'akinsho/toggleterm.nvim', --------------------- Add support for terminal, quick open with ctrl-t and <index>-ctrl-t
        tag = 'v1.*',
        config = function()
            require('toggleterm').setup {}
        end
    }

    use {
        'natecraddock/workspaces.nvim', ---------------- Add support for multiple workspace
        config = function()
            require('workspaces').setup {hooks = {open = {'BCloseAll'}}}
        end
    }
end)
