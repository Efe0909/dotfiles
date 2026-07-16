local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('clangd', {})
h.formatter({ 'c', 'cpp' }, 'clang_format', {
  prepend_args = { '--style=file:' .. vim.fn.expand '$HOME/.config/nvim/format/.clang-format' },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

return {}
