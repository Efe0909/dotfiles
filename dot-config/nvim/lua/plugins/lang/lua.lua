local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('lua_ls', {
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
      format = { enable = false },
    },
  },
})
h.formatter('lua', 'stylua')
return {}
