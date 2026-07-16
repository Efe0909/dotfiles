local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('html', { filetypes = { 'html', 'twig', 'hbs' } })
h.lsp('cssls', {})
h.lsp('tailwindcss', {})
return {}
