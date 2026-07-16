local M = {}
local _fmt_q = {}
local _lint_q = {}
local _registered = false

local function ensure_registered()
  if _registered then return end
  _registered = true
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyDone',
    once = true,
    callback = function()
      local ok, conform = pcall(require, 'conform')
      if ok then
        for _, item in ipairs(_fmt_q) do
          for _, ft in ipairs(item.fts) do
            conform.formatters_by_ft[ft] = item.names
          end
          if item.opts then conform.formatters[item.names[1]] = item.opts end
        end
      end
      local ok2, lint = pcall(require, 'lint')
      if ok2 then
        for _, item in ipairs(_lint_q) do
          for _, ft in ipairs(item.fts) do
            lint.linters_by_ft[ft] = item.names
          end
        end
      end
    end,
  })
end

function M.lsp(tbl, server, opts)
  table.insert(tbl, server)
  vim.lsp.config(server, opts or {})
  vim.lsp.enable(server)
end

function M.formatter(tbl, ft, name, opts)
  table.insert(tbl, name)
  ensure_registered()
  local fts = type(ft) == 'table' and ft or { ft }
  local names = type(name) == 'table' and name or { name }
  table.insert(_fmt_q, { fts = fts, names = names, opts = opts })
end

function M.linter(tbl, ft, name)
  table.insert(tbl, name)
  ensure_registered()
  local fts = type(ft) == 'table' and ft or { ft }
  local names = type(name) == 'table' and name or { name }
  table.insert(_lint_q, { fts = fts, names = names })
end

function M.bind(tbl)
  return {
    lsp       = function(server, opts)   M.lsp(tbl, server, opts) end,
    formatter = function(ft, name, opts) M.formatter(tbl, ft, name, opts) end,
    linter    = function(ft, name)       M.linter(tbl, ft, name) end,
  }
end

return M
