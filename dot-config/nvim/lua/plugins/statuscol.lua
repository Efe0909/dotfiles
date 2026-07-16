return {
  'luukvbaal/statuscol.nvim',
  config = function()
    local builtin = require 'statuscol.builtin'
    require('statuscol').setup {
      setopt = true, -- Auto-set 'statuscolumn' option
      segments = {
        -- Fold column (Clean arrows)
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        -- Sign column (Git/Diagnostics)
        { text = { '%s' }, click = 'v:lua.ScSa' },
        -- Line number (with padding)
        { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
      },
    }
  end,
}
