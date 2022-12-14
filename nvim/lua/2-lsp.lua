-- This file contain setup for lsp servers
local lsp_installer = require 'nvim-lsp-installer'
local init_checker = false
local lspconfig = require 'lspconfig'
local navic = require 'nvim-navic'

-- Language server configuration
local javascript_opts = require 'servers.javascript'
local html_opts = require 'servers.html'
local efm_opts = require 'servers.efm'
local eslint_opts = require 'servers.eslint'
local lua_opts = require 'servers.lua'
local rust_opts = require 'servers.rust'
local tailwindcss_opts = require 'servers.tailwindcss'
local go_opts = require 'servers.go'

-- Config supported servers
local servers = {
  'bashls', 'pyright', 'clangd', 'yamlls', 'cssls', 'tsserver', 'eslint', 'jsonls', 'sumneko_lua',
  'efm', 'vimls', 'cssmodules_ls', 'dockerls', 'dotls', 'html', 'jsonls', 'tailwindcss',
  'cssmodules_ls', 'rust_analyzer', 'gopls'
}
-- Pr-esetup
lsp_installer.setup {}

-- Checking if all servers is installed
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    init_checker = true
    server:install()
  end
end
if init_checker then
  -- Show installer if not install any of LSP
  require 'nvim-lsp-installer'.info_window.open()
end

-- Default attach for all server
local attach_default = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- Specific server configuration
local enhance_server_opts = {
  ['tsserver'] = javascript_opts,
  ['eslint'] = eslint_opts,
  ['efm'] = efm_opts,
  ['html'] = html_opts,
  ['sumneko_lua'] = lua_opts,
  ['emmet_ls'] = function(opts)
    opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
    opts.filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' }
  end,
  ['tailwindcss'] = tailwindcss_opts,
  ['gopls'] = gopls_opts
}

-- Bind into LSP
for _, server in ipairs(servers) do
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
    .make_client_capabilities())
  -- Specify the default options which we'll use to setup all servers
  local opts = { capabilities = capabilities, on_attach = attach_default }
  if enhance_server_opts[server] then
    -- Enhance the default opts with the server-specific ones
    enhance_server_opts[server](opts)
  end
  if server == 'rust_analyzer' then
    require('rust-tools').setup(rust_opts(opts))
  else
    lspconfig[server].setup(opts)
  end
end

local lsp = vim.lsp
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true
})

lsp.handlers['textDocument/hover'] = lsp.with(vim.lsp.handlers.hover, { border = 'single' })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(vim.lsp.handlers.signature_help,
  { border = 'single' })
