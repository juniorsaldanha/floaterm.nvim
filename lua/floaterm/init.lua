local log = require("floaterm.log")
local config = require("floaterm.config")
local tManager = require("floaterm.terminal")

---@class Floaterm
local M = {}
M.__index = M

---@class Configuration
---@field width number Width of the floaterm
---@field height number Height of the floaterm
---@field border string|tuple Border style of the floaterm

---@param id string Terminal ID
---@param lhs string Key mapping for the terminal
---@param opts Configuration Options for the terminal
M.register_terminal = function(id, lhs, opts)
  local terminal = tManager:new(id, lhs, opts)
  if not terminal then
    log.error("Failed to register terminal with ID: %s", id)
    return nil
  end
  return terminal
end

function setup_close_all_keymap()
  local close_all_lhs = "<leader>tc"
  vim.keymap.set(
    { "n", "t" }, close_all_lhs,
    function()
      for _, terminal in pairs(tManager.terminals) do
        tManager.close(terminal.id)
      end
    end,
    { noremap = true, silent = true, desc = "Close all terminals" }
  )
end

M.setup = function(opts)
  if opts then
    config:set(opts)
  end

  setup_close_all_keymap()
end

return M
