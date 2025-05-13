vim.api.nvim_create_user_command("FloatermStart", function()
  package.loaded["floaterm"] = nil

  local floaterm = require("floaterm")
  floaterm.setup()
  floaterm.register_terminal("terminal_backslash", "<C-_>", {
    width = 0.9,
    height = 0.9,
    border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
  })
  floaterm.register_terminal("terminal1", "<leader>t1")
  floaterm.register_terminal("terminal2", "<leader>t2")
end, {})
