-- Allows editing quarto notebooks in nvim --

return {
  'quarto-dev/quarto-nvim',
  dependencies = {
    'jmbuhr/otter.nvim',
    opts = {},
    config = function()
      require('otter').setup {
        lsp = {
          diagnostic_update_events = { 'BufWritePost', 'InsertLeave', 'TextChanged' },
        },
      }
    end,
  },
  lspFeatures = {
    -- NOTE: put whatever languages you want here:
    languages = { 'r', 'python', 'rust' },
    chunks = 'all',
    diagnostics = {
      enabled = true,
      triggers = { 'BufWritePost', 'InsertLeave', 'TextChanged' },
    },
    completion = {
      enabled = true,
    },
  },
  -- keymap = {
  --   -- NOTE: setup your own keymaps:
  --   hover = 'H',
  --   definition = 'gd',
  --   rename = '<leader>rn',
  --   references = 'gr',
  --   format = '<leader>gf',
  -- },
  codeRunner = {
    enabled = true,
    default_method = 'molten',
  },
  ft = { 'quarto', 'markdown' },
}
