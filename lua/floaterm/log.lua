local M = {}
M.enable = false

---@param msg string Message to log
---@param level number Log level (default: INFO)
M.log = function(msg, level)
  if not M.enable then
    return
  end
  vim.notify(
    msg,
    level or vim.log.levels.INFO,
    { title = "Floaterm" }
  )
end

---@param msg string Message to log
---@param ... any Additional arguments to format the message
M.debug = function(msg, ...)
  local formatted_msg = string.format(msg, ...)
  M.log(
    formatted_msg,
    vim.log.levels.DEBUG
  )
end

---@param msg string Message to log
---@param ... any Additional arguments to format the message
M.info = function(msg, ...)
  local formatted_msg = string.format(msg, ...)
  M.log(
    formatted_msg,
    vim.log.levels.INFO
  )
end

---@param msg string Message to log
---@param ... any Additional arguments to format the message
M.warn = function(msg, ...)
  local formatted_msg = string.format(msg, ...)
  M.log(
    formatted_msg,
    vim.log.levels.WARN
  )
end

---@param msg string Message to log
---@param ... any Additional arguments to format the message
M.error = function(msg, ...)
  local formatted_msg = string.format(msg, ...)
  M.log(
    formatted_msg,
    vim.log.levels.ERROR
  )
end

---@param msg string Message to log
---@param ... any Additional arguments to format the message
M.trace = function(msg, ...)
  local formatted_msg = string.format(msg, ...)
  M.log(
    formatted_msg,
    vim.log.levels.TRACE
  )
end

return M
