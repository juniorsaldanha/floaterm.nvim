---@class Configuration
---@field width number Width of the floaterm
---@field height number Height of the floaterm
---@field border string|table Border style of the floaterm
---@field close_all_keymap string Key mapping to close all terminals
---@field timeout number Timeout for keymap waiting
---@field cmd string|nil Command to execute (nil for default shell)
local config = {
  width = 0.75,
  height = 0.75,
  border = "rounded",
  close_all_keymap = "<leader>tc",
  timeout = 150,
  cmd = nil,
}

---@param self Configuration Configuration object
---@param opts table Options to set
---@return Configuration Updated configuration object
function config:set(opts)
  for key, value in pairs(opts) do
    if self[key] ~= nil then
      self[key] = value
    else
      error("Invalid configuration key: " .. key)
    end
  end
  return self
end

return config
