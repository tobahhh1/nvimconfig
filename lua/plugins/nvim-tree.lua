local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.8
local PREVIEW_WIDTH_RATIO = 0.5

_G.nvim_tree_preview_win_id = nil
_G.nvim_tree_preview_buf_id = nil

local get_nvim_tree_window_dimensions = function()
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  local width = math.floor(win_width * WIDTH_RATIO)
  local height = math.floor(win_height * HEIGHT_RATIO)

  local row = math.floor((win_height - height) / 2 - 1)
  local col = math.floor((win_width - width) / 2)
  return col, row, width, height
end

local open_nvim_tree = function()
  local api = require 'nvim-tree.api'

  local x, y, width, height = get_nvim_tree_window_dimensions()

  local preview_width = math.floor(width * PREVIEW_WIDTH_RATIO)
  local preview_x = math.floor(x + (width - preview_width))

  local preview_buf = vim.api.nvim_create_buf(false, true)
  local preview_win_id = vim.api.nvim_open_win(preview_buf, false, {
    relative = 'win',
    win = 0,
    width = preview_width,
    height = height,
    row = y,
    col = preview_x,
    border = 'rounded',
  })
  _G.nvim_tree_preview_buf_id = preview_buf
  _G.nvim_tree_preview_win_id = preview_win_id

  api.tree.open()
end

local close_nvim_tree = function()
  local api = require 'nvim-tree.api'
  vim.api.nvim_win_close(_G.nvim_tree_preview_win_id, false)
  api.tree.close()
end

local open_in_nvim_tree_preview = function()
  local api = require 'nvim-tree.api'
  local node = api.tree.get_node_under_cursor()

  if node and node.type == 'file' then
    -- Check if your floating window still exists
    if _G.nvim_tree_preview_win_id and vim.api.nvim_win_is_valid(_G.nvim_tree_preview_win_id) then
      -- Switch to the floating window and open the file
      vim.api.nvim_win_call(_G.nvim_tree_preview_win_id, function()
        vim.cmd('edit ' .. node.absolute_path)
      end)
    else
      print 'Floating window no longer exists'
    end
  end
end
local open_file_nvim_tree = function()
  local api = require 'nvim-tree.api'
  local node = api.tree.get_node_under_cursor()
  local tmp_window = vim.api.nvim_get_current_win()

  -- Close preview window if we are opening a file
  if node and node.type == 'file' then
    -- Weird jank but have to do this to get the LSP to start
    -- TODO find out why the hell this is the case
    open_in_nvim_tree_preview()
    if _G.nvim_tree_preview_win_id then
      vim.api.nvim_win_close(_G.nvim_tree_preview_win_id, false)
    end
  end

  api.node.open.edit(node)

  if node and node.type == 'file' then
    vim.api.nvim_win_close(tmp_window, false)
  end
end

return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    {
      '\\',
      open_nvim_tree,
      desc = 'Toggle File Explorer',
    },
  },
  opts = {
    update_focused_file = {

      enable = true,
    },
    view = {
      float = {
        enable = true,
        quit_on_focus_loss = false,
        open_win_config = function()
          local x, y, width, height = get_nvim_tree_window_dimensions()

          local explorer_width = math.floor(width * (1 - PREVIEW_WIDTH_RATIO))

          -- Open the floating window
          local win = {
            relative = 'win',
            win = 0, -- 0 means current window
            width = explorer_width,
            height = height,
            row = y,
            col = x,
            style = 'minimal',
            border = 'rounded',
          }
          return win
        end,
      },
      width = function()
        return math.floor(vim.api.nvim_win_get_width(0) * WIDTH_RATIO * (1 - PREVIEW_WIDTH_RATIO))
      end,
    },
    disable_netrw = true,
    hijack_netrw = true,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    on_attach = function(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Preview hovered file --
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = bufnr,
        callback = open_in_nvim_tree_preview,
      })

      vim.keymap.set('n', '<Esc>', close_nvim_tree, opts 'Close nvim tree')
      vim.keymap.set('n', '\\', close_nvim_tree, opts 'Close nvim tree')
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set('n', '<Tab>', open_in_nvim_tree_preview, opts 'Open in side preview window')
      vim.keymap.set('n', '<CR>', open_file_nvim_tree, opts 'Open file')
    end,
  },
}
