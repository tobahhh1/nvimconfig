local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    {
      '\\',
      '<cmd>NvimTreeToggle<CR>',
      desc = 'Toggle File Explorer',
    },
  },
  opts = {
    view = {
      float = {
        enable = true,
        open_win_config = function()
          -- Get the dimensions of the current window
          local win_width = vim.api.nvim_win_get_width(0)
          local win_height = vim.api.nvim_win_get_height(0)

          local width = math.floor(win_width * WIDTH_RATIO)
          local height = math.floor(win_height * HEIGHT_RATIO)

          -- Compute top-left corner to center the window
          local row = math.floor((win_height - height) / 2 - 1)
          local col = math.floor((win_width - width) / 2)

          -- Create a new empty buffer (scratch)
          local buf = vim.api.nvim_create_buf(false, true)

          -- Open the floating window
          local win = {
            relative = 'win',
            win = 0, -- 0 means current window
            width = width,
            height = height,
            row = row,
            col = col,
            style = 'minimal',
            border = 'rounded',
          }
          return win
        end,
      },
      width = function()
        return math.floor(vim.api.nvim_win_get_width(0) * WIDTH_RATIO)
      end,
    },
  },
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
}
