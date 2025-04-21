local log = require("floaterm.log")
local config = require("floaterm.config")

local augroup = vim.api.nvim_create_augroup("floaterm", { clear = true })

---@class Terminal
---@field id string
---@field buf number
---@field win number
---@field lhs string

---@class TerminalManager
---@field terminals table<string, Terminal>
local M = {
  terminals = {},
}
M.__index = M

---@param self TerminalManager Terminal manager object
---@param id string Terminal ID
---@param lhs string Key mapping for the terminal
---@param opts table Options for the terminal
---@return Terminal Terminal object
function M:new(id, lhs, opts)
  if self.terminals[id] then
    log.warn("Terminal with ID %s already exists", id)
    return self.terminals[id]
  end

  local terminal = {
    id = id,
    buf = vim.api.nvim_create_buf(false, true),
    win = nil,
  }
  setmetatable(terminal, self)
  self.terminals[id] = terminal

  local _config = vim.tbl_deep_extend("force", {}, config, opts or {})

  vim.keymap.set(
    { "n", "t" }, lhs,
    function()
      self:toggle(id, _config)
    end,
    { noremap = true, silent = true, desc = "Toggle terminal " .. id }
  )

  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = augroup,
    callback = function()
      if terminal.win and vim.api.nvim_get_current_win() ~= terminal.win then
        self:hide(id)
        log.debug("Floaterm focus lost, hiding terminal: %s", id)
      end
    end,
  })

  log.debug("Created new terminal: %s", id)
  return terminal
end

---@param id string Terminal ID
---@return Terminal|nil Terminal object or nil if not found
function M:get(id)
  if not self.terminals[id] then
    log.warn("Terminal with ID %s not found", id)
    return nil
  end

  return self.terminals[id]
end

---@param id string Terminal ID
---@return boolean True if the terminal was deleted, false if not found
function M:delete(id)
  local terminal = self.terminals[id]
  if not terminal then
    log.warn("Terminal with ID %s not found", id)
    return false
  end

  vim.keymap.del("n", terminal.lhs)

  vim.api.nvim_buf_delete(terminal.buf, { force = true })
  table.remove(self.terminals, id)
  log.debug("Deleted terminal: %s", id)
  return true
end

---@param id string Terminal ID
---@param opts table Options for the terminal
---@return Terminal Terminal object
function M:toggle(id, opts)
  local terminal = self.terminals[id]
  if not terminal then
    log.warn("Terminal with ID %s not found", id)
    return nil
  end

  if terminal.win then
    self:hide(id)
  else
    self:show(id, opts)
  end

  return terminal
end

---@param self TerminalManager Terminal manager object
---@param id string Terminal ID
---@param opts table Options for the terminal
function M:show(id, opts)
  local terminal = self.terminals[id]
  if not terminal then
    log.warn("Terminal with ID %s not found", id)
    return
  end

  if terminal.win then
    log.warn("Terminal window %s is already visible", id)
    return
  end

  local width = opts.width or config.width
  local height = opts.height or config.height
  local border = opts.border or config.border

  if not vim.api.nvim_buf_is_valid(terminal.buf) then
    log.warn("Terminal buffer %s is not valid", id)
    self.terminals[id].buf = vim.api.nvim_create_buf(false, true)
  end
  local ui = vim.api.nvim_list_uis()[1]
  local win_opts_centered = {
    relative = "editor",
    width = math.floor(ui.width * width),
    height = math.floor(ui.height * height),
    col = math.floor((ui.width - (ui.width * width)) / 2),
    row = math.floor((ui.height - (ui.height * height)) / 2),
    style = "minimal",
    border = border,
  }

  terminal.win = vim.api.nvim_open_win(terminal.buf, true, win_opts_centered)

  vim.api.nvim_buf_set_option(terminal.buf, "buflisted", false)
  vim.api.nvim_win_set_option(terminal.win, "winhl", "Normal:Normal")
  vim.api.nvim_win_set_option(terminal.win, "winblend", 0)
  vim.api.nvim_win_set_option(terminal.win, "winhighlight", "Normal:Normal")

  if vim.bo[terminal.buf].buftype ~= "terminal" then
    vim.cmd.terminal()
  end

  if vim.api.nvim_get_mode().mode ~= "i" then
    vim.cmd.startinsert()
  end

  log.debug("Shown terminal window: %s", id)
end

---@param self TerminalManager Terminal manager object
---@param id string Terminal ID
function M:hide(id)
  if id == nil then
    log.warn("Terminal ID is nil")
    return
  end

  local terminal = self.terminals[id]
  if terminal == nil then
    log.warn("Terminal with ID %s not found", id)
    return
  end

  if terminal.win then
    if vim.api.nvim_win_is_valid(terminal.win) then
      vim.api.nvim_win_close(terminal.win, true)
    end
    terminal.win = nil
    log.debug("Hidden terminal window: %s", id)
  else
    log.warn("Terminal window %s is already hidden", id)
  end
end

---@param id string Terminal ID
---@param opts table Options for the terminal
---@return Terminal Terminal object
function M:open(id, opts)
  local _ = self:new(id, opts)
  return self:toggle(id, opts)
end

---@param self TerminalManager Terminal manager object
---@param id string Terminal ID
function M:close(id)
  if self.terminals == nil or #self.terminals == 0 then
    log.warn("No terminals to close")
    return
  end

  local terminal = self.terminals[id]
  if not terminal then
    log.warn("Terminal with ID %s not found", id)
    return
  end

  self.hide(id)

  if terminal.buf then
    vim.api.nvim_buf_delete(terminal.buf, { force = true })
    terminal.buf = nil
    log.debug("Deleted terminal buffer: %s", id)
  end

  table.remove(self.terminals, id)
end

function M:delete_all()
  for id, terminal in pairs(self.terminals) do
    if terminal.win then
      vim.api.nvim_win_close(terminal.win, true)
      terminal.win = nil
      log.debug("Closed terminal window: %s", id)
    end

    M.delete(id)
    log.debug("Deleted terminal: %s", id)
  end
end

return M
