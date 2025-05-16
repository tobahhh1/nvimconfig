local model_config_path = vim.fn.stdpath 'config' .. '/ollama_model.txt'

local function save_ollama_adapter_schema(model, num_ctx)
  local file = io.open(model_config_path, 'w')
  if file then
    file:write(model, '\n')
    file:write(num_ctx, '\n')
    file:close()
  end
end

local function load_ollama_adapter_schema()
  local file = io.open(model_config_path, 'r')
  if file then
    local model = file:read '*l'
    local num_ctx = tonumber(file:read '*l')
    file:close()
    return {
      model = {
        default = model,
      },
      num_ctx = {
        default = num_ctx,
      },
      num_predict = {
        default = -1,
      },
    }
  end
  return {
    model = {
      default = 'stable-code:3b',
    },
    num_ctx = {
      default = 4096,
    },
    num_predict = {
      default = -1,
    },
  }
end
local function load_codecompanion_config()
  return {
    strategies = {
      chat = {
        adapter = 'curr_adapter',
      },
      inline = {
        adapter = 'curr_adapter',
      },
    },
    adapters = {
      curr_adapter = function()
        return require('codecompanion.adapters').extend('ollama', {
          name = 'curr_adapter', -- Give this adapter a different name to differentiate it from the default ollama adapter
          schema = load_ollama_adapter_schema(),
        })
      end,
    },
  }
end

-- CodeCompanion
local model = load_ollama_adapter_schema().model.default
local num_ctx = load_ollama_adapter_schema().num_ctx.default
require('codecompanion').setup(load_codecompanion_config())

vim.api.nvim_create_user_command('CodeCompanionSetModel', function(opts)
  model = opts.args
  save_ollama_adapter_schema(model, num_ctx)
  require('codecompanion').setup(load_codecompanion_config())
end, { nargs = 1 })

vim.api.nvim_create_user_command('CodeCompanionSetNumCtx', function(opts)
  num_ctx = tostring(opts.args)
  save_ollama_adapter_schema(model, num_ctx)
  require('codecompanion').setup(load_codecompanion_config())
end, { nargs = 1 })

vim.keymap.set('n', '<leader>ci', ':CodeCompanion ', { desc = 'Open Code Companion inline command' })
vim.keymap.set('n', '<leader>cc', ':CodeCompanionChat<CR>', { desc = 'Open Code Companion chat' })
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
