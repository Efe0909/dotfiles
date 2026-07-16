-- Autocommands
-- See :help autocmd

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto-Save/Load View (Persist Folds)
vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*.*',
  callback = function()
    if vim.bo.modifiable then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*.*',
  callback = function()
    if vim.bo.modifiable then
      vim.cmd.loadview { mods = { emsg_silent = true } }
    end
  end,
})

-- Session per project: ~/.local/share/nvim/sessions/%Users%Efe%projects%foo.vim
-- Keyed on project root so launching from a subdir hits the same session, not a new one.
local session_dir = vim.fn.stdpath 'data' .. '/sessions'

-- Tiers, strongest first: every ancestor is tested against a whole tier before the
-- next tier is tried. Within a tier the nearest ancestor wins.
--
-- Order is the load-bearing part. Markers that only ever sit at a project root must
-- outrank per-package manifests, or a monorepo resolves to the sub-package: mdapp has
-- Makefile at the root but Cargo.toml at the root AND in every crate, so ranking
-- Cargo.toml first would make crates/editor its own "project". Same reason
-- CMakeLists.txt ranks low -- cmake drops one in every subdirectory.
local session_markers = {
  { '.git', '.hg', '.svn', '.jj' }, -- VCS root: the real answer when it exists
  { 'Makefile', 'go.work', 'pnpm-workspace.yaml', 'flake.nix', 'deno.json' }, -- root-only
  { -- per-package manifests
    'Cargo.toml',
    'go.mod',
    'package.json',
    'pyproject.toml',
    'setup.py',
    'build.zig',
    'CMakeLists.txt',
    'meson.build',
    'Package.swift',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'Gemfile',
    'composer.json',
    'mix.exs',
  },
  { 'requirements.txt', '.venv', 'compile_commands.json', '.luarc.json' }, -- last resort
}

-- nil when cwd isn't in a project, which means: no session, don't save one.
local function project_root()
  for _, tier in ipairs(session_markers) do
    local found = vim.fs.find(tier, {
      path = vim.fn.getcwd(),
      upward = true,
      stop = vim.env.HOME, -- ~ and anything above it is never a project
      limit = 1,
    })[1]
    if found then
      return vim.fs.dirname(found)
    end
  end
  return nil
end

local function session_file()
  local root = project_root()
  if not root then
    return nil
  end
  return session_dir .. '/' .. root:gsub('/', '%%') .. '.vim'
end

-- A session holding nothing but an empty buffer would clobber a real one saved earlier.
local function has_real_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= '' then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Save session for the current directory',
  group = vim.api.nvim_create_augroup('session-persist', { clear = true }),
  callback = function()
    local file = session_file()
    if not file or not has_real_buffers() then
      return
    end
    -- Plugin windows replay as splits over dead buffers; close before saving.
    pcall(vim.cmd, 'Neotree close')
    vim.fn.mkdir(session_dir, 'p')
    vim.cmd('mksession! ' .. vim.fn.fnameescape(file))
  end,
})

vim.api.nvim_create_user_command('SessionRestore', function()
  local file = session_file()
  if not file then
    vim.notify('Not in a project: ' .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(file) == 0 then
    vim.notify('No session for ' .. project_root(), vim.log.levels.WARN)
    return
  end
  vim.cmd('source ' .. vim.fn.fnameescape(file))
end, { desc = 'Restore session for the current project' })
