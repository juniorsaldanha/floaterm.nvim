<p align="center">
  <h1 align="center">floaterm.nvim</h1>
</p>

<p align="center">
  <a href="https://github.com/juniorsaldanha/floaterm.nvim/stargazers">
    <img alt="Stars" src="https://img.shields.io/github/stars/juniorsaldanha/floaterm.nvim?style=for-the-badge&logo=starship&color=c678dd&logoColor=d9e0ee&labelColor=282a36">
  </a>
  <a href="https://github.com/juniorsaldanha/floaterm.nvim/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/juniorsaldanha/floaterm.nvim?style=for-the-badge&logo=gitbook&color=f0c062&logoColor=d9e0ee&labelColor=282a36">
  </a>
  <a href="https://github.com/juniorsaldanha/floaterm.nvim/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/juniorsaldanha/floaterm.nvim?style=for-the-badge&logo=github&color=a6e3a1&logoColor=d9e0ee&labelColor=282a36">
  </a>
</p>

<p align="center">
  <b>Elegant floating terminals for Neovim</b>
</p>

<p align="center">
  A minimal, fast, and beautifully simple floating terminal manager for Neovim.<br>
  Register unlimited terminals, each with its own keymap. Toggle instantly. Stay in flow.
</p>

---

## ✨ Features

- **Multiple Independent Terminals** — Register as many terminals as you need, each with unique keybindings
- **TUI App Integration** — Launch lazygit, btop, claude, or any TUI app in a dedicated floating window
- **Per-Terminal Customization** — Different sizes, borders, and commands for each terminal
- **Smart Focus Management** — Terminals auto-hide when focus is lost
- **Telescope Integration** — Browse and manage terminals with Telescope (optional)
- **Zero Dependencies** — Pure Lua, works out of the box

## 📸 Demo

<!-- Add your demo GIF here -->
<!-- ![floaterm.nvim demo](https://user-images.githubusercontent.com/demo.gif) -->

## 🚀 Quick Start

```lua
-- Toggle a terminal with <C-\>
require("floaterm").register_terminal("main", "<C-\\>")
```

That's it. Press `<C-\>` to toggle your floating terminal.

## 📦 Installation

<details>
<summary><b>lazy.nvim</b> (recommended)</summary>

```lua
{
  "juniorsaldanha/floaterm.nvim",
  config = function()
    require("floaterm").setup()
  end,
}
```

</details>

<details>
<summary><b>packer.nvim</b></summary>

```lua
use {
  "juniorsaldanha/floaterm.nvim",
  config = function()
    require("floaterm").setup()
  end,
}
```

</details>

<details>
<summary><b>vim-plug</b></summary>

```vim
Plug 'juniorsaldanha/floaterm.nvim'

" In your init.lua or after/plugin:
lua require("floaterm").setup()
```

</details>

<details>
<summary><b>mini.deps</b></summary>

```lua
MiniDeps.add({ source = "juniorsaldanha/floaterm.nvim" })
require("floaterm").setup()
```

</details>

## ⚙️ Configuration

```lua
require("floaterm").setup({
  width = 0.75,              -- Width as percentage of editor (0.0 to 1.0)
  height = 0.75,             -- Height as percentage of editor (0.0 to 1.0)
  border = "rounded",        -- Border style: "rounded", "single", "double", "shadow", or custom
  close_all_keymap = "<leader>tc",  -- Keymap to close all terminals
  timeout = 150,             -- Keymap timeout when terminal is open (ms)
})
```

### Border Styles

```lua
-- Built-in styles
border = "rounded"  -- ╭─╮│╯─╰│
border = "single"   -- ┌─┐│┘─└│
border = "double"   -- ╔═╗║╝═╚║
border = "shadow"   -- Shadow effect

-- Custom border
border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
```

## 📖 Usage

### Basic Terminal

```lua
local floaterm = require("floaterm")

floaterm.setup()

-- Register terminals with unique IDs and keymaps
floaterm.register_terminal("main", "<C-\\>")
floaterm.register_terminal("secondary", "<leader>t2")
floaterm.register_terminal("third", "<leader>t3")
```

### TUI Applications

Launch your favorite TUI apps in dedicated floating windows:

```lua
local floaterm = require("floaterm")

-- Lazygit
floaterm.register_app("lazygit", "<leader>gg", "lazygit", {
  width = 0.9,
  height = 0.9,
})

-- Btop system monitor
floaterm.register_app("btop", "<leader>tb", "btop")

-- Claude AI
floaterm.register_app("claude", "<leader>tc", "claude")

-- Node.js REPL
floaterm.register_app("node", "<leader>tn", "node")

-- Python REPL
floaterm.register_app("python", "<leader>tp", "python3")
```

### Per-Terminal Customization

Each terminal can have its own appearance:

```lua
-- Small terminal at bottom-ish area
floaterm.register_terminal("small", "<leader>ts", {
  width = 0.5,
  height = 0.3,
  border = "single",
})

-- Large terminal for complex tasks
floaterm.register_terminal("large", "<leader>tl", {
  width = 0.95,
  height = 0.95,
  border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
})
```

### Full Example Configuration

```lua
{
  "juniorsaldanha/floaterm.nvim",
  keys = {
    { "<C-\\>", desc = "Toggle main terminal" },
    { "<leader>gg", desc = "Lazygit" },
    { "<leader>t1", desc = "Terminal 1" },
    { "<leader>t2", desc = "Terminal 2" },
    { "<leader>tc", desc = "Close all terminals" },
  },
  config = function()
    local floaterm = require("floaterm")

    floaterm.setup({
      width = 0.8,
      height = 0.8,
      border = "rounded",
    })

    -- Main terminal
    floaterm.register_terminal("main", "<C-\\>")

    -- Numbered terminals for parallel tasks
    floaterm.register_terminal("t1", "<leader>t1")
    floaterm.register_terminal("t2", "<leader>t2")

    -- Lazygit integration
    floaterm.register_app("lazygit", "<leader>gg", "lazygit", {
      width = 0.9,
      height = 0.9,
    })
  end,
}
```

## 🔌 API

### `setup(opts?)`

Initialize floaterm with optional configuration.

```lua
require("floaterm").setup({
  width = 0.75,
  height = 0.75,
  border = "rounded",
  close_all_keymap = "<leader>tc",
  timeout = 150,
})
```

### `register_terminal(id, keymap, opts?)`

Register a new terminal with a unique ID and toggle keymap.

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique identifier for the terminal |
| `keymap` | `string` | Keymap to toggle this terminal |
| `opts` | `table?` | Optional per-terminal configuration |

```lua
floaterm.register_terminal("my-term", "<leader>tt", {
  width = 0.8,
  height = 0.8,
  border = "double",
})
```

### `register_app(id, keymap, cmd, opts?)`

Register a terminal that runs a specific command/application.

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique identifier for the terminal |
| `keymap` | `string` | Keymap to toggle this terminal |
| `cmd` | `string` | Command to execute |
| `opts` | `table?` | Optional per-terminal configuration |

```lua
floaterm.register_app("lazygit", "<leader>gg", "lazygit")
```

### `list_terminals()`

Returns a list of all registered terminals.

```lua
local terminals = floaterm.list_terminals()
-- Returns: { { id = "main", lhs = "<C-\\>" }, ... }
```

### `set_timeout(ms)`

Set the keymap timeout when terminals are visible.

```lua
floaterm.set_timeout(100)
```

## 🔭 Telescope Integration

Optional Telescope extension for terminal management.

```lua
-- Load the extension
require("telescope").load_extension("floaterm")

-- Use it
:Telescope floaterm
```

**Requirements:** [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## ⌨️ Default Keymaps

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>tc` | n, t | Close all floating terminals |
| *Your registered keymaps* | n, t | Toggle specific terminal |

## 🎯 Tips

**Escaping terminal mode:** Use `<C-\><C-n>` to exit terminal mode, then your registered keymap to hide the terminal.

**Workflow suggestion:** Register `<C-\>` for your main terminal and use `<leader>t1`, `<leader>t2`, etc. for auxiliary terminals.

**Lazygit users:** Use `register_app` with a larger window size for a better git experience.

## 📋 Requirements

- Neovim >= 0.8.0
- Optional: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for Telescope integration

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ for the Neovim community
</p>
