return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install({
      'lua', 'python', 'javascript', 'typescript', 'vimdoc', 'vim',
      'regex', 'terraform', 'sql', 'dockerfile', 'toml', 'json', 'java',
      'groovy', 'go', 'gitignore', 'graphql', 'yaml', 'make', 'cmake',
      'markdown', 'markdown_inline', 'bash', 'tsx', 'css', 'html', 'c',
    }):wait(300000)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
