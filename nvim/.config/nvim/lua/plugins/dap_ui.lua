local dap_ui = require('dapui')
local dap = require('dap')


-- open ui immediately when debuging starts
dap.listeners.after.event_initialized['dapui_config'] = function() dap_ui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dap_ui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dap_ui.close() end

dap_ui.setup({
  expand_lines = false,
  controls = { enabled = false },
  floating = { border = 'rounded' },
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 1.0 }
      },
      size = 15,
      position = 'bottom',
    },
  },
})
