return {
  'github/copilot.vim',
  lazy = false,
  init = function()
    -- Remap the accept key to Avoid collision with nvim-cmp <Tab>
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    -- Accepted Bindings
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('i', '<C-t>', 'copilot#Accept("<CR>")', { silent = true, expr = true })

    -- Dismiss / Quit
    vim.keymap.set('i', '<C-q>', 'copilot#Dismiss()', { expr = true, silent = true })

    -- Custom keymap for floating Copilot panel
    vim.keymap.set('n', '<leader>cp', function()
      vim.cmd 'Copilot panel'
      -- Get the window that just opened (Copilot panel splits by default)
      local win = vim.api.nvim_get_current_win()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      -- Convert the split window to a floating window
      vim.api.nvim_win_set_config(win, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
      })

      -- Optional: Map 'q' or '<Esc>' to close the float easily if not already handled
      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = true, silent = true })
    end, { desc = '[C]opilot [P]anel (Floating)' })

    -- Custom keymap to Toggle Copilot
    vim.keymap.set('n', '<leader>ct', function()
      if vim.fn['copilot#Enabled']() == 1 then
        vim.cmd 'Copilot disable'
        print 'Copilot OFF'
      else
        vim.cmd 'Copilot enable'
        print 'Copilot ON'
      end
    end, { desc = '[C]opilot [T]oggle' })
  end,
}
