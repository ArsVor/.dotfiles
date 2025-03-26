-- Create an autocommand for "BufWritePost" events
vim.api.nvim_create_autocmd('BufWritePost', {
  -- This autocommand will only trigger if the buffer name matches the following patterns
  pattern = { '*.scss', '*.sass' },
  -- The autocommand will trigger the following lua function
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
