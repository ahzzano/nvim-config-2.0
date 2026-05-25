vim.o.background = "dark"
vim.o.backup = false
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.number = true
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 50
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.g.mapleader = ' '

vim.opt.relativenumber = true
vim.opt.number = true

-- Keymaps
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })

vim.keymap.set('n', 'Y', 'yy')
vim.keymap.set('v', '<C-c>', '"+y')

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', 'sv', '<C-w>v', { noremap = true, silent = true })
vim.keymap.set('n', 'sx', '<C-w>s', { noremap = true, silent = true })

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', "<leader>cf", vim.lsp.buf.format, opts)
end

local open_lazygit = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_tabpage(buf, true, {})

    vim.fn.termopen('lazygit', {
        on_exit = function()
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    })
    vim.cmd('startinsert')
end

vim.keymap.set('n', '<leader>gg', open_lazygit, {})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = on_attach
})

-- Plugins
-- Theme
vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
vim.cmd.colorscheme('vague')

-- Autopairs
vim.pack.add({
    { src = 'https://github.com/windwp/nvim-autopairs' }
})
require('nvim-autopairs').setup()

-- nvim.surround
vim.pack.add({
    { src = 'https://github.com/kylechui/nvim-surround' }
})
require('nvim-surround').setup()

-- Treesitter
vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = "main",
    },
})
require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
})

require("nvim-treesitter").install({
    "lua",
    "javascript",
    "dockerfile",
    "rust",
    "go",
    "python",
    "c",
    "cpp",
    "svelte"
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end
})

-- LSP Config
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

vim.pack.add({
    'https://github.com/rcarriga/nvim-notify'
})
vim.notify = require("notify")

vim.lsp.config("rust_analyzer", { on_attach = on_attach })

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("clangd")
vim.lsp.enable("svelte")
vim.lsp.enable("biome")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("dockerls")
vim.lsp.enable("pyright")
vim.lsp.enable('lua_ls')
vim.lsp.enable("ts_ls")

vim.pack.add({
    {
        src = 'https://github.com/JavaHello/spring-boot.nvim',
        version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
    },
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/mfussenegger/nvim-dap',

    'https://github.com/nvim-java/nvim-java',
})

require('java').setup()
vim.lsp.enable('jdtls')
-- Blink.cmp
vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
})
require("blink.cmp").setup({
    keymap = { preset = 'enter' },
    appearance = {
        nerd_font_variant = 'mono'
    },
    completion = { documentation = { auto_show = true } },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust" }
})

vim.pack.add({
    'https://github.com/dmtrKovalenko/fff.nvim'
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('fff.nvim') end
            require('fff.download').download_or_build_binary()
        end
    end
})

vim.g.fff = {
    lazy_sync = true,
}

vim.keymap.set('n', '<leader>ff', function()
    require('fff').find_files()
end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fz', function()
    require('fff').live_grep()
end, { noremap = true, silent = true })

-- Filemanager
-- vim.pack.add({
--     'https://github.com/stevearc/oil.nvim'
-- })
-- require('oil').setup()

-- vim.keymap.set("n", "<leader>pv", '<CMD>Oil<CR>', {})
vim.pack.add({
    'https://github.com/nvim-mini/mini.files'
})
require('mini.files').setup()
vim.keymap.set("n", "<leader>pv", MiniFiles.open, {})

-- Gitsigns
vim.pack.add({
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})
require('gitsigns').setup({
    current_line_blame = true,
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
    signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- jump to hunks
        vim.keymap.set('n', ']h', function() gs.nav_hunk("next") end, {})
        vim.keymap.set('n', ']h', function() gs.nav_hunk("prev") end, {})

        -- stage/reset
        vim.keymap.set({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", {})
        vim.keymap.set({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", {})

        vim.keymap.set({ "n", "v" }, "<leader>ghS", gs.stage_buffer, {})
        vim.keymap.set({ "n", "v" }, "<leader>ghR", gs.reset_buffer, {})
    end
})

-- Undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require('undotree').open)

-- Markdown stuff
vim.pack.add({
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/iamcco/markdown-preview.nvim",
})

-- Debugger Stuff
vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
})

local dap = require('dap')

-- Some commands
vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = '+', desc = 'Delete plugins (space separated)' })
