return {
  'mrcjkb/rustaceanvim',
  -- https://github.com/mrcjkb/rustaceanvim
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy

  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- ✅ Встановлюємо ширину табів
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].softtabstop = 4
          vim.bo[bufnr].expandtab = true

          -- 🔑 Keymaps
          local keymap = vim.keymap.set
          local opts = { silent = true, buffer = bufnr }

          keymap('n', '<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, opts)

          keymap('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, opts)

          -- 🧹 Автоформат при збереженні (тільки якщо підтримується сервером)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('RustAutoFormat', { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false } -- Синхронно, щоб зберігалось після форматування
              end,
            })
          end
        end,
      },
    }
  end,
}
