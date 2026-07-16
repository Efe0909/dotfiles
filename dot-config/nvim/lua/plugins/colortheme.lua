-- return {
--   'shaunsingh/nord.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- Example config in lua
--     vim.g.nord_contrast = true
--     vim.g.nord_borders = false
--     vim.g.nord_disable_background = true
--     vim.g.nord_italic = false
--     vim.g.nord_uniform_diff_background = true
--     vim.g.nord_bold = false
--
--     -- Load the colorscheme
--     require('nord').set()
--
--     -- Toggle background transparency
--     local bg_transparent = true
--
--     local toggle_transparency = function()
--       bg_transparent = not bg_transparent
--       vim.g.nord_disable_background = bg_transparent
--       vim.cmd [[colorscheme nord]]
--     end
--
--     vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
--   end,
-- }

-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('catppuccin').setup {
--       flavour = 'mocha',
--       transparent_background = true,
--       term_colors = true,
--       integrations = {
--         treesitter = true,
--         telescope = { enabled = true },
--         gitsigns = true,
--         mini = { enabled = true },
--         which_key = true,
--         native_lsp = {
--           enabled = true,
--           underlines = {
--             errors = { 'undercurl' },
--             hints = { 'undercurl' },
--             warnings = { 'undercurl' },
--             information = { 'undercurl' },
--           },
--         },
--       },
--     }
--
--     vim.cmd.colorscheme 'catppuccin'
--
--     local bg_transparent = true
--     vim.keymap.set('n', '<leader>bg', function()
--       bg_transparent = not bg_transparent
--       require('catppuccin').setup { flavour = 'mocha', transparent_background = bg_transparent }
--       vim.cmd.colorscheme 'catppuccin'
--     end, { noremap = true, silent = true })
--   end,
-- }

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'night',
      transparent = true,
      terminal_colors = true,
    }

    vim.cmd.colorscheme 'tokyonight'

    local bg_transparent = true
    vim.keymap.set('n', '<leader>bg', function()
      bg_transparent = not bg_transparent
      require('tokyonight').setup { style = 'night', transparent = bg_transparent }
      vim.cmd.colorscheme 'tokyonight'
    end, { noremap = true, silent = true })
  end,
}
