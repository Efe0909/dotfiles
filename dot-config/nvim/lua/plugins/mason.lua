return {
  -- Mason: package manager for LSP servers, linters, and formatters
  'mason-org/mason.nvim',
  dependencies = {
    -- Bridges LSP config names (e.g. "lua_ls") to Mason package names (e.g. "lua-language-server")
    'mason-org/mason-lspconfig.nvim',
    -- Installs any Mason-managed tool by name; used by lsp.lua, conform.lua, lint.lua
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()
  end,
}
