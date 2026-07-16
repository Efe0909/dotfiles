local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local s = ls.snippet
local i = ls.insert_node

return {
  s(
    'fori',
    fmta(
      [[
    for <var> in <start>..<stop> {
        <body>
    }
  ]],
      {
        var = i(1, 'i'),
        start = i(2, '0'),
        stop = i(3, 'n'),
        body = i(0),
      }
    )
  ),

  s(
    'fore',
    fmta(
      [[
    for <item> in <coll> {
        <body>
    }
  ]],
      {
        item = i(1, 'item'),
        coll = i(2, '&collection'),
        body = i(0),
      }
    )
  ),

  s(
    'while',
    fmta(
      [[
    while <cond> {
        <body>
    }
  ]],
      {
        cond = i(1, 'condition'),
        body = i(0),
      }
    )
  ),

  s(
    'ifelse',
    fmta(
      [[
    if <cond> {
        <then_arm>
    } else {
        <else_arm>
    }
  ]],
      {
        cond = i(1, 'condition'),
        then_arm = i(2),
        else_arm = i(0),
      }
    )
  ),

  -- `[]` delimiters, not fmta's `<>`: match arms contain a literal `=>`.
  s(
    'match',
    fmt(
      [[
    match [expr] {
        [pat] => [arm],
        _ => [default],
    }
  ]],
      {
        expr = i(1, 'expr'),
        pat = i(2, 'pattern'),
        arm = i(3, 'todo!()'),
        default = i(0, 'todo!()'),
      },
      { delimiters = '[]' }
    )
  ),
}
