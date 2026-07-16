return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function is_copilot_loaded()
      return vim.fn.exists('*copilot#Enabled') == 1
    end

    local function copilot_status()
      local icon = '' -- Octocat
      if not is_copilot_loaded() then return '' end
      
      local status = vim.fn['copilot#Enabled']() == 1
      if status then
        return icon
      else
        return ''
      end
    end

    local function copilot_color()
      if not is_copilot_loaded() then return { fg = '#5c6370' } end -- Grey if not loaded
      
      if vim.fn['copilot#Enabled']() == 1 then
        return { fg = '#98c379' } -- Green
      else
        return { fg = '#e06c75' } -- Red
      end
    end

    local function ts_node()
      local mode = vim.fn.mode()
      if not (mode:find('^[vV\22]')) then return '' end
      
      local node = vim.treesitter.get_node()
      if not node then return '' end
      
      return ' ' .. node:type()
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { ts_node, 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          {
            copilot_status,
            color = copilot_color,
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      extensions = { 'neo-tree', 'lazy' },
    }
  end,
}
