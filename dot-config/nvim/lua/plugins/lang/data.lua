local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('sqlls', {})
h.lsp('jsonls', {})
h.lsp('yamlls', {})
h.lsp('terraformls', {})
h.formatter('sql', 'sql_formatter', {
  command = 'sql-formatter',
  args = { '--language', 'mysql' },
  stdin = true,
})
return {}
