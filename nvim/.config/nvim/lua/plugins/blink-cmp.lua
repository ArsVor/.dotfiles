return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    {
      'Kaiser-Yang/blink-cmp-dictionary',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    'rafamadriz/friendly-snippets',
    'MahanRahmati/blink-nerdfont.nvim',
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
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

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',

      kind_icons = {
        Text = '󰉿',
        Method = 'm',
        Function = '󰊕',
        Constructor = '󰒓',

        Field = '󰜢',
        Variable = '󰆧',
        Property = '󰖷',

        Class = '󰌗',
        Interface = '󱡠',
        Struct = '',
        Module = '󰅩',

        Unit = '󰪚',
        Value = '󰎠',
        Enum = '󰦨',
        EnumMember = '',

        Keyword = '󰌋',
        Constant = '󰏿',

        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈙',
        Reference = '',
        Folder = '󰉋',
        Event = '󱐋',
        Operator = '󰆕',
        TypeParameter = '󰊄',
      },
    },

    completion = {
      menu = {
        border = 'double',
        winblend = 10,
        scrollbar = false,
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
        },
      },
      documentation = {
        auto_show = true,
        window = {
          winblend = 10,
          border = 'single',
        },
      },
      ghost_text = {
        enabled = false,
      },
    },

    signature = {
      enabled = true,
      trigger = {
        show_on_insert = false,
        show_on_insert_on_trigger_character = false,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dictionary', 'nerdfont' },
      providers = {
        nerdfont = {
          module = 'blink-nerdfont',
          name = 'Nerd Fonts',
          score_offset = 15, -- Tune by preference
          opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
          should_show_items = function()
            return vim.tbl_contains(
              -- Enable emoji completion only for git commits and markdown.
              -- By default, enabled for all file-types.
              { 'gitcommit', 'markdown', 'text' },
              vim.o.filetype
            )
          end,
        },
        dictionary = {
          module = 'blink-cmp-dictionary',
          name = 'Dict',
          score_offset = -14,
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 4,
          opts = {
            -- options for blink-cmp-dictionary
            dictionary_files = {
              vim.fn.expand '~/.config/nvim/dictionary/words_alpha.txt',
              vim.fn.expand '~/.config/nvim/dictionary/ukrain-words.txt',
            },
          },
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
