local blink = require('blink.cmp')

blink.setup({
  fuzzy = { implementation = 'prefer_rust' },
  keymap = {
    preset = 'default',

    ['<C-space>'] = { 'show', 'hide' },
    ['<C-e>'] = { 'show_documentation', 'hide_documentation' },
    ['<C-y>'] = { 'select_and_accept', 'fallback' },
    ['<Tab>'] = { 'select_and_accept', 'fallback' },

    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    ['<C-l>'] = { 'snippet_forward', 'select_and_accept', 'fallback' },
    ['<C-h>'] = { 'snippet_backward', 'hide', 'fallback' },

    ['<C-p>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },


  -- snippets = {
  --   expand = function(snippet)
  --     require("luasnip").lsp_expand(snippet)
  --   end,
  -- },
  completion = {
    menu = {
      border = 'double',
      winblend = 10,
      scrollbar = false,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = {
        winblend = 10,
        border = 'single',
      },
    },
    ghost_text = {
      enabled = true,
    },
  },

  sources = {
    -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- Use a preset for snippets, check the snippets documentation for more information
  -- snippets = { preset = 'default' | 'luasnip' | 'mini_snippets' | 'vsnip' },

  -- Experimental signature help support
  signature = { enabled = true }
})
