local arrows = require('core.icons').arrows

-- Set up icons.
local icons = {
  Stopped = { '', 'DiagnosticWarn', 'DapStoppedLine' },
  Breakpoint = '',
  BreakpointCondition = '',
  BreakpointRejected = { '', 'DiagnosticError' },
  LogPoint = arrows.right,
}
for name, sign in pairs(icons) do
  sign = type(sign) == 'table' and sign or { sign }
  vim.fn.sign_define('Dap' .. name, {
        -- stylua: ignore
        text = sign[1] --[[@as string]] .. ' ',
    texthl = sign[2] or 'DiagnosticInfo',
    linehl = sign[3],
    numhl = sign[3],
  })
end

return {
  -- nvim-dap https://github.com/mfussenegger/nvim-dap
  -- nvim-dap-ui https://github.com/rcarriga/nvim-dap-ui
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      keys = {
        {
          '<leader>de',
          function()
            -- Calling this twice to open and jump into the window.
            require('dapui').eval()
            require('dapui').eval()
          end,
          desc = 'Evaluate expression',
        },
      },
      opts = {
        icons = {
          collapsed = arrows.right,
          current_frame = arrows.right,
          expanded = arrows.down,
        },
        floating = { border = 'rounded' },
        layouts = {
          {
            elements = {
              { id = 'stacks', size = 0.30 },
              { id = 'breakpoints', size = 0.20 },
              { id = 'scopes', size = 0.50 },
            },
            position = 'left',
            size = 40,
          },
        },
      },
    },
    'nvim-neotest/nvim-nio',
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = { virt_text_pos = 'eol' },
    },
    'williamboman/mason.nvim',
    -- JS/TS debugging.
    -- {
    --   'mxsdev/nvim-dap-vscode-js',
    --   opts = {
    --     debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
    --     adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    --   },
    -- },
    -- {
    --   'microsoft/vscode-js-debug',
    --   build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
    -- },
    -- -- Lua adapter.
    {
      'jbyuki/one-small-step-for-vimkind',
      keys = {
        {
          '<leader>dl',
          function()
            require('osv').launch { port = 8086 }
          end,
          desc = 'Launch Lua adapter',
        },
      },
    },
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dap_ui_widgets = require 'dap.ui.widgets'
    local dapui = require 'dapui'

    require('dapui').setup()
    require('nvim-dap-virtual-text').setup {
      display_callback = function(variable)
        if #variable.value > 15 then
          return ' ' .. string.sub(variable.value, 1, 15) .. '... '
        end

        return ' ' .. variable.value
      end,
    }

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Python configurations.
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or '127.0.0.1'
        cb {
          type = 'server',
          port = assert(port, '`connect.port` is required for a python `attach` configuration'),
          host = host,
          options = {
            source_filetype = 'python',
          },
        }
      else
        cb {
          type = 'executable',
          command = '/usr/bin/python',
          args = { '-m', 'debugpy.adapter' },
          options = {
            source_filetype = 'python',
          },
        }
      end
    end

    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch',
        name = 'Launch file',

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = '${file}', -- This configuration will launch the current file if used.
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
    }

    -- Debug Django projects
    local function django_debug()
      for _, config in ipairs(dap.configurations.python) do
        if config.name == 'Run Django Server' then
          -- require('dap').continue()
          return
        end
      end

      table.insert(dap.configurations.python, {
        -- type = 'python',
        -- request = 'launch',
        -- name = 'Run Django Server',
        -- program = '${workspaceFolder}/manage.py',
        -- args = { 'runserver', '--noreload', '--nothreading' },
        type = 'python',
        request = 'attach',
        name = 'Attach to Django',
        connect = {
          host = '127.0.0.1',
          port = 5678,
        },
        django = true,
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      })
      -- require('dap').continue()
    end
    vim.api.nvim_create_user_command('Drun', django_debug, {})

    -- Use overseer for running preLaunchTask and postDebugTask.
    -- require('overseer').patch_dap(true)
    -- require('dap.ext.vscode').json_decode = require('overseer.json').decode

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
      ---@diagnostic disable-next-line: undefined-field
      callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
    end
    dap.configurations['lua'] = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
      },
    }

    -- C configurations.
    dap.adapters.codelldb = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- dap.adapters.lua = {
    --   type = 'executable',
    --   command = 'lua', -- Або шлях до вашого Lua інтерпретатора
    --   args = { '-e', 'require("debugger")()' },
    -- }
    --
    -- dap.configurations.lua = {
    --   {
    --     type = 'lua',
    --     request = 'launch',
    --     name = 'Debug Lua File',
    --     program = function()
    --       return vim.fn.input('Path to file: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --   },
    -- }

    -- Add configurations from launch.json
    require('dap.ext.vscode').load_launchjs(nil, {
      ['codelldb'] = { 'c' },
      ['pwa-node'] = { 'typescript', 'javascript' },
    })

    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = 'Toggle [B]reakpoint' })
    vim.keymap.set('n', '<Leader>bx', dap.clear_breakpoints, { desc = 'Clear [B]reakpoint' })
    vim.keymap.set('n', '<Leader>db', dap.run_to_cursor, { desc = 'Run' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step [I]nto' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step [O]ver' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Step o[U]t' })
    -- vim.keymap.set('n', '<leader>db', dap.step_back, { desc = 'Step [B]ack' })
    vim.keymap.set('n', '<leader>dr', dap.restart, { desc = '[R]estart' })
    vim.keymap.set('n', '<Leader>dx', dap.terminate, { desc = 'Terminate' })
    vim.keymap.set('n', '<Leader>lp', function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
    end, { desc = 'Set breakpoint' })
    vim.keymap.set('n', '<Leader>dr', dap.repl.open, { desc = 'Open dap-[R]epl buff' })
    -- vim.keymap.set('n', '<Leader>dl', dap.run_last, { desc = 'Toggle [B]reakpoint' })
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', dap_ui_widgets.hover, { desc = 'Widget [H]over' })
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', dap_ui_widgets.preview, { desc = 'Widget [P]review' })
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.frames)
    end, { desc = 'Open [F]rames float widget' })
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end, { desc = 'Open [S]copes float widget' })
  end,
}
