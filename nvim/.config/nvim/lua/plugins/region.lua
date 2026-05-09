vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "#region,#endregion"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

local region = require('region-folding')

region.setup({
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    region_text = { start = "#region", ending = "#endregion" },
    fold_indicator = "▼"
  }
})
