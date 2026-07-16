return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'BufReadPost', -- Load after buffer read
  config = function()
    local ufo = require 'ufo'

    -- Set up options
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Custom keymaps
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)

    -- global handler
    -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
    -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' ⋯ %d lines '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      
      -- Check for FOLD: tag
      local lineText = ''
      for _, chunk in ipairs(virtText) do
        lineText = lineText .. chunk[1]
      end
      
      local foldDesc = lineText:match('.*FOLD:%s*(.*)')
      if foldDesc then
        -- Custom fold text mapping
        table.insert(newVirtText, { '  ' .. foldDesc, 'SpecialComment' })
        curWidth = vim.fn.strdisplaywidth(newVirtText[1][1])
      else
        -- Standard handling
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
      end
      
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    ufo.setup {
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype)
        -- markdown has complex injected parsers (fenced code blocks) that can
        -- trigger a nil-node race in Neovim 0.12's languagetree.lua; use
        -- indent-based folding for those filetypes instead.
        local ts_unsupported = { markdown = true, markdown_inline = true, help = true }
        if ts_unsupported[filetype] then
          return { 'indent' }
        end
        return { 'treesitter', 'indent' }
      end,
    }
  end,
}
