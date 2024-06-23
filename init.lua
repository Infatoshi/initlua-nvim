-- Leader key configuration
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Basic Keymaps
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

-- Highlight yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Configuration
require('lazy').setup(
  {
    'tpope/vim-sleuth',
    { 'numToStr/Comment.nvim', opts = {} },
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },
    {
      'folke/which-key.nvim',
      event = 'VimEnter',
      config = function()
        require('which-key').setup()
        require('which-key').register {
          ['<leader>c'] = { name = '[C]ode' },
          ['<leader>d'] = { name = '[D]ocument' },
          ['<leader>r'] = { name = '[R]ename' },
          ['<leader>s'] = { name = '[S]earch' },
          ['<leader>w'] = { name = '[W]orkspace' },
        }
      end,
    },
    {
      'melbaldove/llm.nvim',
      dependencies = { 'nvim-neotest/nvim-nio' },
      config = function()
        require('llm').setup {
          timeout_ms = 10000,
          services = {
            groq = {
              url = 'https://api.groq.com/openai/v1/chat/completions',
              model = 'llama3-70b-8192',
              api_key_name = 'GROQ_API_KEY',
            },
            openai = {
              url = 'https://api.openai.com/v1/chat/completions',
              model = 'gpt-4o',
              api_key_name = 'OPENAI_API_KEY',
            },
            anthropic = {
              url = 'https://api.anthropic.com/v1/messages',
              model = 'claude-3-5-sonnet-20240620',
              api_key_name = 'ANTHROPIC_API_KEY',
            },
            -- Custom provider example
            other_provider = {
              url = 'https://example.com/other-provider/v1/chat/completions',
              model = 'llama3',
              api_key_name = 'OTHER_PROVIDER_API_KEY',
            },
          },
        }

        -- Example keybindings
        vim.keymap.set('n', '<leader>m', function()
          require('llm').create_llm_md()
        end)

        -- keybinds for prompting with anthropic
        vim.keymap.set('n', '<leader>,', function()
          require('llm').prompt { replace = false, service = 'anthropic' }
        end)
        vim.keymap.set('v', '<leader>,', function()
          require('llm').prompt { replace = false, service = 'anthropic' }
        end)
        vim.keymap.set('v', '<leader>.', function()
          require('llm').prompt { replace = true, service = 'anthropic' }
        end)

        -- keybinds for prompting with openai
        vim.keymap.set('n', '<leader>g,', function()
          require('llm').prompt { replace = false, service = 'openai' }
        end)
        vim.keymap.set('v', '<leader>g,', function()
          require('llm').prompt { replace = false, service = 'openai' }
        end)
        vim.keymap.set('v', '<leader>g.', function()
          require('llm').prompt { replace = true, service = 'openai' }
        end)
      end,
    },
    {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup {
          disable_netrw = true,
          hijack_netrw = true,
          auto_reload_on_write = true,
          open_on_tab = false,
          update_cwd = true,
          update_focused_file = {
            enable = true,
            update_cwd = true,
          },
          view = { width = 30, side = 'left' },
        }
      end,
    },
    {
      'sainnhe/everforest',
      config = function()
        vim.cmd 'colorscheme everforest'
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('telescope').setup {
          extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
        }
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags)
        vim.keymap.set('n', '<leader>sk', builtin.keymaps)
        vim.keymap.set('n', '<leader>sf', builtin.find_files)
        vim.keymap.set('n', '<leader>ss', builtin.builtin)
        vim.keymap.set('n', '<leader>sw', builtin.grep_string)
        vim.keymap.set('n', '<leader>sg', builtin.live_grep)
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
        vim.keymap.set('n', '<leader>sr', builtin.resume)
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles)
        vim.keymap.set('n', '<leader><leader>', builtin.buffers)
        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
        end)
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            map('K', vim.lsp.buf.hover, 'Hover Documentation')
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
              })
            end
          end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
          lua_ls = {
            settings = {
              Lua = {
                completion = { callSnippet = 'Replace' },
              },
            },
          },
        }

        require('mason').setup()
        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(ensure_installed, { 'stylua' })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }
        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },
    {
      'stevearc/conform.nvim',
      opts = { notify_on_error = false, format_on_save = { timeout_ms = 500, lsp_fallback = true }, formatters_by_ft = { lua = { 'stylua' } } },
    },
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        { 'L3MON4D3/LuaSnip', build = (vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0) and nil or 'make install_jsregexp' },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },
          mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
          },
        }
      end,
    },
    {
      'iamcco/markdown-preview.nvim',
      cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
      ft = { 'markdown' },
      build = function()
        vim.fn['mkdp#util#install']()
      end,
    },
    {
      'loctvl842/monokai-pro.nvim',
      priority = 1000,
      init = function()
        vim.cmd.colorscheme 'monokai-pro'
      end,
    },
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    {
      'echasnovski/mini.nvim',
      config = function()
        require('mini.ai').setup { n_lines = 500 }
        require('mini.surround').setup()
        local statusline = require 'mini.statusline'
        statusline.setup { use_icons = vim.g.have_nerd_font }
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      opts = {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'markdown_inline' },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
        indent = { enable = true, disable = { 'ruby' } },
      },
      config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
      end,
    },
  },
  -- Adding black-nvim for Python formatting
  {
    'psf/black',
    cmd = 'Black', -- Only load when the :Black command is run
    ft = { 'python' },
    config = function()
      vim.cmd [[
        augroup autoformat
          autocmd!
          autocmd BufWritePre *.py :Black
        augroup END
      ]]
    end,
  },
  {
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)

vim.cmd [[
  augroup markdown_settings
    autocmd!
    autocmd FileType markdown setlocal spell textwidth=80
  augroup END
]]

-- vim: ts=2 sts=2 sw=2 et
