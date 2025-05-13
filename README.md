# `floaterm.nvim`

## Description
`floaterm.nvim` is a Neovim plugin that provides a floating terminal window. It allows you to run shell commands and interact with the terminal in a floating window, making it easy to work with terminal output without leaving your current editing context.

## Features
- Floating terminal window
- Support for multiple terminal instances
- Customizable terminal size and borders
- Key mappings for easy navigation and management of terminal instances

## Setup
### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "juniorsaldanha/floaterm.nvim",
  config = function()
    local floaterm = require("floaterm")
    floaterm.setup({
        width = 0.8, -- Width of the floating terminal window (0.0 to 1.0)
        height = 0.8, -- Height of the floating terminal window (0.0 to 1.0)
        border = "rounded", -- Border style (rounded, single, double, shadow, custom border e.g { "╔", "═", "╗", "║", "╝", "═", "╚", "║" })
    })

    -- Key mappings for toggling the floating terminal
    -- `opts` is optional and can be used to pass additional options to the terminal
    floaterm.register_terminal("terminal_backslash", "<C-_>", {
      width = 0.9,
      height = 0.9,
      border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    })
    floaterm.register_terminal("terminal1", "<leader>t1")
    floaterm.register_terminal("terminal2", "<leader>t2")
  end,
}
```

## Key Mappings
- `<leader>tc` - Close all floating terminals

## LICENSE
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

