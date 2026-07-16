return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    local wk = require 'which-key'
    wk.setup()

    -- Document existing keychains
    wk.add {
      { '<leader>c', group = '[C]ode / Copilot' },
      { '<leader>p', group = '[P]ane Management' },
      { '<leader>d', group = '[D]ocument / Debug' },
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle / Tabs' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>ng', group = '[N]eo-tree [G]it' },
      { 's', group = '[S]urround' },
    }

    -- Register manual descriptions for hidden keys
    wk.add {
      -- Core / Window
      { '<leader>sn', desc = '[S]earch [N]eovim files' },
      { '<leader>e', desc = 'Explorer (Netrw)' },
      { '<leader>lw', desc = 'Toggle Line Wrap' },

      -- Tab Management
      { '<leader>tn', desc = 'Tab Next' },
      { '<leader>tp', desc = 'Tab Previous' },
      { '<leader>to', desc = 'Tab Open New' },
      { '<leader>tx', desc = 'Tab Close' },

      -- Pane Management
      { '<leader>pv', desc = 'split window vertically' },
      { '<leader>ph', desc = 'split window horizontally' },
      { '<leader>pse', desc = 'make split windows equal width & height' },
      { '<leader>pxs', desc = 'close current split window' },

      -- Copilot Manually Registered (if not auto-picked)
      { '<leader>cp', desc = 'Copilot Panel' },
      { '<leader>ct', desc = 'Copilot Toggle' },

      -- Toggle Keys
      { '<leader>th', desc = 'Toggle Inlay Hints' },
      { '<leader>tb', desc = 'Toggle Git Blame' },
      { '<leader>tD', desc = 'Toggle Deleted' },

      -- Mini.Surround
      { 'sa', desc = 'Add Surround', mode = { 'n', 'v' } },
      { 'sd', desc = 'Delete Surround' },
      { 'sr', desc = 'Replace Surround' },
      { 'sf', desc = 'Find Surround' },
      { 'sh', desc = 'Highlight Surround' },

      -- Marks
      { 'mx', desc = 'Set mark x' },
      { 'm,', desc = 'Set next available mark' },
      { 'm;', desc = 'Toggle next available mark' },
      { 'dmx', desc = 'Delete mark x' },
      { 'dm-', desc = 'Delete all marks on line' },
      { 'dm<space>', desc = 'Delete all marks in buffer' },
      { 'm]', desc = 'Move to next mark' },
      { 'm[', desc = 'Move to previous mark' },
      { 'm:', desc = 'Preview mark' },
      { 'm0', desc = 'Add bookmark group [0-9]' },
      { 'dm0', desc = 'Delete bookmark group [0-9]' },
      { 'm}', desc = 'Move to next bookmark (same type)' },
      { 'm{', desc = 'Move to previous bookmark (same type)' },
      { 'dm=', desc = 'Delete bookmark under cursor' },
    }
  end,
}
