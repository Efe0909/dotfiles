return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
          if err then
            vim.notify('Format failed: ' .. err, vim.log.levels.ERROR)
          else
            vim.notify('Buffer formatted', vim.log.levels.INFO)
          end
        end)
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end
    end,
  },
}
