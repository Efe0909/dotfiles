local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  -- Pragma once
  s('once', {
    t '#pragma once',
  }),

  -- Class definition
  s(
    'class',
    fmt(
      [[
    class {name} {{
    public:
        {name}();
        ~{name}();

    private:
        {}
    }};
  ]],
      {
        name = i(1, 'ClassName'),
        i(2),
      }
    )
  ),

  -- Include guard (optional alternative to pragma)
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

  -- Function prototype
  s(
    'func',
    fmt(
      [[
    {ret} {name}({args});
  ]],
      {
        ret = i(1, 'void'),
        name = i(2, 'functionName'),
        args = i(3, ''),
      }
    )
  ),
}
