-- AI Helper for code
return {
  'olimorris/codecompanion.nvim',
  opts = {
    strategies = {
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
      actions = {
        adapter = 'copilot',
      },
    },
    display = {
      diff = {
        enabled = true,
        provider = 'mini_diff',
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
