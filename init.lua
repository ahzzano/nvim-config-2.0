vim.g.mapleader = " "
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

vim.opt.relativenumber = true
vim.opt.number = true

-- Keymaps
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })

vim.keymap.set('n', 'Y', 'yy')
vim.keymap.set('v', '<C-c>', '"+y')

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap=true, silent=true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap=true, silent=true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap=true, silent=true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap=true, silent=true })

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

end

local open_lazygit = function ()
    local buf = vim.api.nvim_create_buf(false, true)
    
    local w = math.floor(vim.o.columns * 0.8)
    local h = math.floor(vim.o.lines* 0.8)
    local r = math.floor((vim.o.lines - h) / 2)
    local c = math.floor((vim.o.columns - w) / 2)

    -- vim.api.nvim_open_win(buf, true, {
    --     relative = 'editor',
    --     width = w, 
    --     height = h, 
    --     row = r - 2, 
    --     col = c,
    --     style = "minimal",
    --     border = "rounded",
    -- })
    vim.api.nvim_open_tabpage(buf, true, {})

    vim.fn.termopen('lazygit', {
        on_exit = function ()
            vim.api.nvim_buf_delete(buf, {force = true})
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
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" },
})
vim.cmd.colorscheme "catppuccin"

-- Autopairs
vim.pack.add({
    { src='https://github.com/windwp/nvim-autopairs' }
})
require('nvim-autopairs').setup()

-- nvim.surround
vim.pack.add({
    {src = 'https://github.com/kylechui/nvim-surround'}
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
    install_dir = vim.fn.stdpath('data') .. '/site'
})
require("nvim-treesitter").install({
	"lua",
	"javascript",
    "dockerfile",
    "rust",
    "go",
    "python",
    "c",
    "cpp"
})

-- LSP Config 
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
})

require('mason').setup()
require('mason-lspconfig').setup()

vim.lsp.config("rust_analyzer", { on_attach = on_attach })

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("clangd")
vim.lsp.enable("svelte")
vim.lsp.enable("biome")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("dockerls")
vim.lsp.enable("pyright")

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

-- Telescope
vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim'
})
require('telescope').setup()
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap=true, silent=true })

-- Filemanager
vim.pack.add({
    'https://github.com/nvim-mini/mini.files'
})
require('mini.files').setup()

vim.keymap.set("n", "<leader>pv", MiniFiles.open, opts)

-- Undotree 
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require('undotree').open)

-- Markdown stuff
vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",
})
