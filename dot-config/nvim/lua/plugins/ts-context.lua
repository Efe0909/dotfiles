return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    -- Disable for filetypes whose injected-language trees trigger the Nvim 0.12
    -- nil-node race in languagetree.lua:215 (markdown fenced code blocks, etc.)
    on_attach = function(buf)
      local ft = vim.bo[buf].filetype
      return ft ~= 'markdown' and ft ~= 'markdown_inline' and ft ~= 'help'
    end,
  },
  keys = {
    { "<leader>tc", "<cmd>TSContext toggle<cr>", desc = "[T]oggle [C]ontext" },
  },
  -- TODO:
  config = function (_,opts)
    require("treesitter-context").setup(opts)
    vim.schedule(function()
      vim.cmd("TSContext enable")
    end)
  end,
}
