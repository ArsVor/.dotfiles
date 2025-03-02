-- Easily comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  opts = {},
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, vim.tbl_extend('force', opts, { desc = 'Toggle comment line' }))
    vim.keymap.set(
      'v',
      '<C-/>',
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      vim.tbl_extend('force', opts, { desc = 'Toggle comment block' })
    )

    -- vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
    -- vim.keymap.set(
    -- 	"v",
    -- 	"<C-_>",
    -- 	"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    -- 	opts
    -- )

    -- vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
    -- vim.keymap.set(
    -- 	"v",
    -- 	"<C-c>",
    -- 	"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    -- 	opts
    -- )
  end,
}
