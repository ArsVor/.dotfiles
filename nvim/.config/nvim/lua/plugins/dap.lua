local dap = require('dap')

dap.adapters.debugpy = function(cb, config) -- also $ uv tool install debugpy@latest
  if config.request == 'attach' then
    cb({
      type = 'server',
      port = config.connect.port,
      host = config.connect.host or '127.0.0.1'
    })
  elseif vim.fn.filereadable(vim.fn.getcwd() .. "/manage.py") == 1 then
    cb({
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    })
  else
    cb({
      type = 'executable',
      command = 'debugpy-adapter',
    })
  end
end

dap.configurations.python = { -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
  {
    name = 'Launch file',
    type = 'debugpy',
    request = 'launch',
    program = '${file}',
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, './venv') or vim.fn.getcwd()
    end,
  },
  {
    name = "Django: runserver",
    type = "debugpy",
    request = "launch",
    program = vim.fn.getcwd() .. "/manage.py",
    args = { "runserver", "--noreload" },
    django = true,
    justMyCode = false,
  },
}


dap.adapters["rust-gdb"] = {
  type = "executable",
  command = "rust-gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "rust-gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    args = function()
      return vim.fn.input('Args: ')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "rust-gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = "${workspaceFolder}"
  },
  {
    name = "Attach to gdbserver :1234",
    type = "rust-gdb",
    request = "attach",
    target = "localhost:1234",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
