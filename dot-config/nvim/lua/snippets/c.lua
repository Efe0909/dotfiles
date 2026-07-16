local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- pointer check via Tree-sitter
local ts_ok, tsu = pcall(require, 'nvim-treesitter.ts_utils')

local function is_pointer_ts(name)
  if not ts_ok then
    return false
  end

  local node = tsu.get_node_at_cursor()
  if not node then
    return false
  end

  ------------------------------------------------------------------
  -- walk up to find a declarator/declaration containing “* name”
  ------------------------------------------------------------------
  local function climb(n)
    while n do
      local t = n:type()
      -- C/C++ grammars call these nodes ‘init_declarator’, ‘pointer_declarator’,
      -- ‘declaration’, ‘field_declaration’, etc.  We’ll just check *every* level.
      local text = vim.treesitter.get_node_text(n, 0)
      if text and text:match('%*%s*' .. name .. '%f[%W]') then
        return true
      end
      -- stop climbing when we leave the line (heuristic)
      if t == 'translation_unit' or t == 'function_definition' then
        break
      end
      n = n:parent()
    end
    return false
  end

  if climb(node) then
    return true
  end

  ------------------------------------------------------------------
  -- fallback: grep earlier lines up to cursor row
  ------------------------------------------------------------------
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
  local pat = '%*%s*' .. name .. '%f[%W]'
  for _, l in ipairs(lines) do
    if l:match(pat) then
      return true
    end
  end

  return false
end

return {
  -- Include guard with filename as macro
  s(
    'guard',
    fmt(
      [[
    #ifndef {GUARD}
    #define {GUARD}

    {}

    #endif // {GUARD}
  ]],
      {
        GUARD = f(function(_, snip)
          local name = snip.env.TM_FILENAME or 'HEADER_H'
          name = name:upper():gsub('%.', '_')
          return name
        end, {}),
        i(1),
      }
    )
  ),

  -- Pragma once
  s('once', {
    t '#pragma once',
  }),

  -- Function declaration
  s(
    'func',
    fmt(
      [[
    {ret} {name}({args});
  ]],
      {
        ret = i(1, 'void'),
        name = i(2, 'function_name'),
        args = i(3, 'void'),
      }
    )
  ),
  -- OOP style method calls in C
  s('this', {
    -- object name
    i(1, 'obj'),

    -- dot or arrow (decided by Tree-sitter)
    f(function(args)
      return is_pointer_ts(args[1][1]) and '->' or '.'
    end, { 1 }),

    -- method name
    i(2, 'method'),
    t '(',

    -- first argument:  obj   vs   &obj
    f(function(args)
      local obj = args[1][1]
      return is_pointer_ts(obj) and obj or ('&' .. obj)
    end, { 1 }),

    t ', ',
    i(3, '/* extra args */'),
    t ')',
    i(0),
  }),
}
