-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- key mapping for quick tab switching.
vim.keymap.set("n", "th", "<cmd>tabprev<CR>")
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "tn", "<cmd>tabnew|lua require('fzf-lua').files()<CR>")
vim.keymap.set("n", "<space>t", "<cmd>lua require('nvim-tree.api').tree.toggle({find_file=true})<CR>")
vim.keymap.set("n", "<space>+", "<cmd>lua vim.g.neovide_scale_factor=vim.g.neovide_scale_factor+0.2<CR>")
vim.keymap.set("n", "<space>-", "<cmd>lua vim.g.neovide_scale_factor=vim.g.neovide_scale_factor-0.2<CR>")
vim.keymap.set("n", "<space>0", "<cmd>lua vim.g.neovide_scale_factor=1.0<CR>")

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.number = true
-- Use spaces instead of tabs for indentation.
vim.opt.signcolumn = "number"
vim.opt.expandtab = true
-- This is to prevent double status bars.
vim.opt.showmode = false
vim.g['loaded_perl_provider'] = 0
vim.g['loaded_ruby_provider'] = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy loading other plugins.
require("lazy").setup({
{
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
    end
  end,
},
{"nvim-tree/nvim-web-devicons"},
{ "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup()
  end
},
{ "junegunn/fzf", build = "./install --bin" },
{
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})
  end
},
{ "tpope/vim-fugitive" },
{ "neovim/nvim-lspconfig" },
{ "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
},
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
},
{
  -- "numiras/semshi",
  "wookayin/semshi", -- use a maintained fork
  ft = "python",
  build = ":UpdateRemotePlugins",
  init = function()
    -- Disabled these features better provided by LSP or other more general plugins
    vim.g["semshi#error_sign"] = false
    vim.g["semshi#simplify_markup"] = false
    vim.g["semshi#mark_selected_nodes"] = false
    vim.g["semshi#update_delay_factor"] = 0.001

    -- This autocmd must be defined in init to take effect
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
      group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
      callback = function()
        -- Only add style, inherit or link to the LSP's colors
            -- highlight! link semshiGlobal  @none
            -- highlight! link semshiImported @none
            -- highlight! link semshiParameter @lsp.type.parameter
            -- --- highlight! link semshiBuiltin @function.builtin
            -- highlight! link semshiAttribute @field
            -- highlight! link semshiSelf @lsp.type.selfKeyword
            -- highlight! link semshiUnresolved @none
            -- highlight! link semshiFree @none
            -- highlight! link semshiAttribute @none
            -- highlight! link semshiParameterUnused @none
        vim.cmd([[
            highlight! link semshiBuiltin @function.builtin
            ]])
      end,
    })
  end,
},
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
}
})
vim.cmd[[colorscheme tokyonight-night]]


-- Configuring treesitter
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- Setting Ctrl-P to open fzf window
vim.keymap.set("n", "fz",
  "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<c-P>",
  "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "ft",
  "<cmd>lua require('fzf-lua').tabs()<CR>", { silent = true })
vim.keymap.set("n", "fb",
  "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.formatting.buildifier,
    null_ls.builtins.formatting.stylua,
  },
})

-- Pyright config by lspconfig
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.tsserver.setup{}
lspconfig.bzl.setup{}
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Status Line
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineAccent#"
  if current_mode == "n" then
      mode_color = "%#StatuslineAccent#"
  elseif current_mode == "i" or current_mode == "ic" then
      mode_color = "%#StatuslineInsertAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
      mode_color = "%#StatuslineVisualAccent#"
  elseif current_mode == "R" then
      mode_color = "%#StatuslineReplaceAccent#"
  elseif current_mode == "c" then
      mode_color = "%#StatuslineCmdLineAccent#"
  elseif current_mode == "t" then
      mode_color = "%#StatuslineTerminalAccent#"
  end
  return mode_color
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." then
      return " "
  end

  return string.format(" %%<%s/", fpath)
end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
      return ""
  end
  return fname .. " "
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError#E " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning#W " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint#H " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation#I " .. count["info"]
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

Statusline = {}

function Statusline.active()
  return table.concat {
    "%#Statusline#",
    update_mode_colors(),
    mode(),
    "%#Normal# ",
    filepath(),
    filename(),
    "%#Normal#",
    lsp(),
    " %{FugitiveStatusline()}",
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  }
end

function Statusline.inactive()
  return " %F"
end

function Statusline.short()
  return "%#StatusLineNC#   NvimTree"
end

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)


-- neovide configuration
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_lifetime = 3.0
