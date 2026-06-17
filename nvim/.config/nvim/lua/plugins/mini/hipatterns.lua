vim.api.nvim_set_hl(0, "MiniHipatternsRegionStart", { fg = "#232a2e", bg = "#e69875", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsRegionEnd", { fg = "#232a2e", bg = "#d699b6", bold = true })
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    regst     = { pattern = '%f[%w]()REG()%f[%W]', group = 'MiniHipatternsRegionStart' },
    regend    = { pattern = '%f[%w]()REGEND()%f[%W]', group = 'MiniHipatternsRegionEnd' },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
