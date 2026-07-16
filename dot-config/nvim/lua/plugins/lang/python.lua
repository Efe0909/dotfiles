local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('ruff', {})
h.lsp('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        mccabe = { enabled = false },
        pylsp_mypy = { enabled = false },
        pylsp_black = { enabled = false },
        pylsp_isort = { enabled = false },
      },
    },
  },
})
return {}
