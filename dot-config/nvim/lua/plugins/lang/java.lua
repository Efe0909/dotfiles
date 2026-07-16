local h = require('lang.helpers').bind(require('lang.tools').list)
h.lsp('jdtls', {
  filetypes = { 'java' },
  root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts' },
  cmd = {
    'jdtls',
    '-data',
    vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = { updateBuildConfiguration = 'interactive' },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = 'all' } },
      format = { enabled = true },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
    },
  },
})
h.formatter('java', 'google-java-format')
return {}
