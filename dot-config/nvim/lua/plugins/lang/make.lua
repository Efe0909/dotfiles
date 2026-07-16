local h = require('lang.helpers').bind(require('lang.tools').list)
h.formatter('make', 'makefmt', { command = 'makefmt' })
h.linter('make', 'checkmake')
return {}
