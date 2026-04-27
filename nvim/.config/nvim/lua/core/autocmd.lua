local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })


-- Set meymap for go to definition
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = 'Go to definition' })
    vim.keymap.set("n", "gw", vim.lsp.buf.workspace_symbol, { buffer = event.buf, desc = 'Show workspace_symbol' })
  end,
})

-- Autostart treesitter for FileType
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Auto compile *.scss & *.sass on save
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup,
  pattern = { '*.scss', '*.sass' },
  callback = function()
    local input_name = vim.fn.expand '%'
    local output_name = input_name:gsub('%.scss$', '.css'):gsub('%.sass$', '.css')
    local cmd = string.format('sass "%s" "%s"', input_name, output_name)
    local result = os.execute(cmd)

    if result ~= 0 then
      print('SASS compilation failed: ' .. cmd)
    else
      print('SASS compiled successfully: ' .. output_name)
    end
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    if not vim.bo[args.buf].modifiable then return end
    if vim.api.nvim_buf_get_name(args.buf) == "" then return end

    vim.lsp.buf.format({
      bufnr = args.buf,
      async = false,
      filter = function(client)
        return client:supports_method("textDocument/formatting")
      end,
    })
  end,
})
