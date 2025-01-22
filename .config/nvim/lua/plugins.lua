-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out,                            'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup({
    -- LSP Stuff
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    {
        'williamboman/mason.nvim',
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = {
                'html',
                'cssls',
                'ts_ls',
                'emmet_language_server',
                'lua_ls',
                'rust_analyzer',
                'gopls',
                'templ',
                'pylsp',
                'ruby_lsp',
            },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                ruby_lsp = function()
                    require('lspconfig').ruby_lsp.setup({
                        init_options = {
                            formatter = 'standard',
                            linters = { 'standard' },
                        },
                    })
                end
            },
        },
    },

    -- Themes
    {
        'sainnhe/gruvbox-material',
        config = function()
            local colorscheme = 'gruvbox-material'
            local ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
            if not ok then
                vim.notify('colorscheme ' .. colorscheme .. ' not found!')
            end
        end,
    },
    { 'HiPhish/rainbow-delimiters.nvim' },

    --Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,

                highlight = {
                    enable = true,
                },
            }
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
    },
    {
        'windwp/nvim-ts-autotag',
        config = true,
    },
    {
        'stevearc/oil.nvim',
        config = true,
    },
    {
        'LunarVim/bigfile.nvim',
        config = true,
    },
})
