local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = {
          '--',
          '-A', 'clippy::doc_overindented_list_items',
          '-A', 'clippy::doc_markdown',
          '-A', 'clippy::doc_lazy_continuation',
        },
      },
      cargo = { allFeatures = true },
      inlayHints = { bindingModeHints = { enable = true } },
    },
  },
})
h.formatter('rust', 'rustfmt')
return {}
