local log = require("floaterm.log")
local config = require("floaterm.config")
local tManager = require("floaterm.terminal")

---@class Floaterm
local M = {}
M.__index = M

---@param id string Terminal ID
---@param lhs string Key mapping for the terminal
---@param opts Configuration Options for the terminal
---@returns Terminal Terminal object
M.register_terminal = function(id, lhs, opts)
  local terminal = tManager:new(id, lhs, opts)
  if not terminal then
    log.error("Failed to register terminal with ID: %s", id)
    return nil
  end
  return terminal
end

---@param id string Terminal ID (e.g., "lazygit", "claude")
---@param lhs string Key mapping for the terminal
---@param cmd string Command/binary to execute (e.g., "lazygit", "claude")
---@param opts Configuration? Optional configuration options
---@returns Terminal Terminal object
M.register_app = function(id, lhs, cmd, opts)
  opts = opts or {}
  opts.cmd = cmd
  return M.register_terminal(id, lhs, opts)
end

---@param timeoutlen number Timeout length for the terminal keymap waiting
M.set_timeout = function(timeoutlen)
  if timeoutlen and type(timeoutlen) == "number" then
    config.timeout = timeoutlen
    log.debug("Timeout length set to: %d", timeoutlen)
  else
    log.warn("Invalid timeout length: %s", timeoutlen)
  end
end

---@returns table List of all registered terminals
M.list_terminals = function()
  local terminals = {}
  for id, terminal in pairs(tManager.terminals) do
    table.insert(terminals, { id = id, lhs = terminal.lhs })
  end
  log.debug("Registered terminals: %s", vim.inspect(terminals))
  return terminals
end

---@param opts Configuration? Options for the floaterm
M.setup = function(opts)
  if opts then
    config:set(opts)
  end
end

return M
