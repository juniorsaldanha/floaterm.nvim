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

---@param id string Terminal ID (e.g., "lazygit", "claude")
---@param lhs string Key mapping for the terminal
---@return boolean True if the set of keymap was successful, false otherwise
M.add_keymap_hide = function(id, lhs)
  local terminal = tManager:get(id)
  if not terminal then
    log.error("Cannot set keymap, terminal with ID %s not found", id)
    return false
  end

  if not terminal.hide_keys then
    terminal.hide_keys = {}
  end
  table.insert(terminal.hide_keys, lhs)

  if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    vim.keymap.set({ "t", "n" }, lhs, function()
      tManager:hide(id)
    end, { buffer = terminal.buf, noremap = true, silent = true, desc = "Hide terminal " .. id })
  end

  log.debug("Added hide keymap for terminal %s: %s", id, lhs)
  return true
end

---@param id string Terminal ID (e.g., "lazygit", "claude")
---@param lhs string Key mapping for the terminal
---@return boolean True if the removal of keymap was successful, false otherwise
M.remove_keymap_hide = function(id, lhs)
  local terminal = tManager:get(id)
  if not terminal then
    log.error("Cannot remove keymap, terminal with ID %s not found", id)
    return false
  end

  if terminal.hide_keys then
    for i = #terminal.hide_keys, 1, -1 do
      if terminal.hide_keys[i] == lhs then
        table.remove(terminal.hide_keys, i)
      end
    end
  end

  if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    pcall(vim.keymap.del, { "t", "n" }, lhs, { buffer = terminal.buf })
  end

  log.debug("Removed hide keymap for terminal %s: %s", id, lhs)
  return true
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
