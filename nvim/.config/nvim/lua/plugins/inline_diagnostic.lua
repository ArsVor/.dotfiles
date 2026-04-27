local tid = require('tiny-inline-diagnostic')

tid.setup({
  options = {
    -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
    show_source = {
      enabled = true,  -- Enable showing source names
      if_many = false, -- Only show source if multiple sources exist for the same diagnostic
    },
  },
  show_all_diags_on_cursorline = true,
})
