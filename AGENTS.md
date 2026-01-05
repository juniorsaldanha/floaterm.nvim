# AGENTS.md

This file provides guidance to AI agents working with code in this repository.

## Project Overview

**floaterm.nvim** is a Neovim plugin that provides floating terminal windows. It allows multiple independent terminal instances with customizable size, borders, and keybindings. Written in pure Lua with zero dependencies.

## Commands

### Running Tests

```bash
make test
```

Tests use plenary.nvim's busted testing framework. Test files are in `tests/` and follow the `*_spec.lua` naming convention. The test runner automatically clones plenary.nvim to `/tmp/plenary.nvim` if not present.

**Note**: The Makefile has a TODO comment indicating tests may not be fully working. Verify test output carefully.

### Manual Testing

```bash
make nvim_minimal
```

Opens Neovim with minimal config. Use `:FloatermStart` command to load the plugin with sample terminals (defined in `plugin/load_floaterm.lua`).

### Formatting

```bash
stylua lua/
```

StyLua is configured via `.stylua.toml`. Run before committing.

## Architecture

### Directory Structure

```
lua/
├── floaterm/
│   ├── init.lua          # Public API entry point
│   ├── terminal.lua      # Terminal manager singleton
│   ├── config.lua        # Configuration defaults and validation
│   └── log.lua           # Logging utility
└── telescope/
    └── _extensions/
        ├── floaterm.lua          # Telescope extension registration
        └── floaterm_builtin.lua  # Telescope picker implementation

tests/
├── minimal_init.lua      # Test bootstrap (loads plenary)
├── floaterm/
│   └── floaterm_spec.lua # Core plugin tests
└── telescope/
    └── telescope_spec.lua # Telescope extension tests

plugin/
└── load_floaterm.lua     # :FloatermStart command for development

scripts/
└── minimal_init.vim      # Minimal vim config for manual testing
```

### Core Modules

| Module | Purpose |
|--------|---------|
| `init.lua` | Public API. Exports `setup()`, `register_terminal()`, `register_app()`, `set_timeout()`, `list_terminals()` |
| `terminal.lua` | `TerminalManager` singleton. Handles terminal lifecycle: creation, show/hide toggling, deletion. Manages floating window positioning and buffer creation |
| `config.lua` | Configuration defaults and validation. Settings: `width`, `height`, `border`, `close_all_keymap`, `timeout`, `cmd` |
| `log.lua` | Logging utility (disabled by default). Set `require("floaterm.log").enable = true` to enable |

### Key Concepts

- **Terminal Registration**: `register_terminal(id, lhs, opts)` creates a terminal bound to a keymap. The keymap works in both normal and terminal mode.

- **App Registration**: `register_app(id, lhs, cmd, opts)` wraps `register_terminal` to run a specific command (e.g., lazygit, claude) instead of the default shell. Apps get additional keymaps (`<Esc>` and `<C-c>`) to hide the window.

- **Timeout Management**: The plugin temporarily reduces `timeoutlen` when terminals are visible to make keymaps more responsive, restoring it when hidden.

- **Auto-hide on Focus Loss**: Terminals automatically hide when focus moves to another window via `WinEnter` autocmd.

- **Singleton Pattern**: `TerminalManager` maintains a `terminals` table that persists across calls. Terminal buffers are reused when toggling.

### Telescope Extension

Optional integration for listing/managing terminals via Telescope picker.

- **Requirements**: telescope.nvim, nvim-treesitter
- **Actions**: `<CR>` toggles terminal, `<C-d>` deletes terminal
- **Location**: `lua/telescope/_extensions/`

## Code Style & Conventions

### Lua Style

- **Indentation**: 2 spaces (configured in `.stylua.toml` and `.editorconfig`)
- **Line width**: 120 characters max
- **Quotes**: Double quotes preferred (auto-prefer)
- **Line endings**: Unix (LF)

### Naming Conventions

- **Modules**: Return a table `M` with functions
- **Private functions**: Local functions not attached to `M`
- **Classes**: Use `@class` LuaDoc annotations
- **Parameters**: Use `@param` and `@return` annotations

### Documentation

- Use LuaDoc-style annotations (`---@class`, `---@param`, `---@return`)
- Document public API functions in `init.lua`
- Keep inline comments minimal

### Module Pattern

```lua
local M = {}
M.__index = M

-- Public function
function M.some_function()
end

-- Or using assignment
M.another_function = function()
end

return M
```

## Testing Patterns

### Test Structure

Tests use plenary.nvim's busted framework:

```lua
describe("feature", function()
  it("does something", function()
    assert(condition, "error message")
  end)
end)
```

### Test Categories

1. **Unit tests** (`tests/floaterm/floaterm_spec.lua`): Test public API functions
2. **Structure tests** (`tests/telescope/telescope_spec.lua`): Verify file structure and patterns

### Running Individual Tests

The test runner runs all `*_spec.lua` files in `tests/`. To run specific tests, modify the `TESTS_DIR` in Makefile temporarily or use plenary's test runner directly.

## Important Gotchas

### Neovim API Usage

- Uses deprecated `nvim_buf_set_option` and `nvim_win_set_option` (should use `vim.bo` and `vim.wo`)
- Uses deprecated `nvim_get_option` and `nvim_set_option` for `timeoutlen`
- Window options set after `nvim_open_win` to ensure window exists

### Terminal Buffer Handling

- Buffers are created with `nvim_create_buf(false, true)` (unlisted, scratch)
- Terminal is started with `vim.fn.termopen(cmd)` or `vim.cmd.terminal()`
- Check `vim.bo[buf].buftype ~= "terminal"` before starting terminal to avoid restarting

### State Management

- `timeout_original` is module-level state tracking original `timeoutlen`
- `tManager.terminals` persists all registered terminals
- Window handle (`terminal.win`) is `nil` when hidden, set when visible

### Deletion Bug

There's a bug in `terminal.lua:111`: `table.remove(self.terminals, id)` should be `self.terminals[id] = nil`. The current code doesn't properly remove terminals from the table since `id` is a string, not an index.

### Focus Detection

The `WinEnter` autocmd fires for each terminal, potentially causing issues if multiple terminals are registered. Each terminal only hides itself when focus is lost.

## Configuration Defaults

```lua
{
  width = 0.75,              -- Percentage of editor width
  height = 0.75,             -- Percentage of editor height
  border = "rounded",        -- Border style
  close_all_keymap = "<leader>tc",
  timeout = 150,             -- Keymap timeout in ms when terminal visible
  cmd = nil,                 -- Command to run (nil = default shell)
}
```

## Dependencies

### Required

- Neovim >= 0.8.0

### Optional

- telescope.nvim (for Telescope integration)
- nvim-treesitter (required by Telescope extension per README, though not directly used)
- plenary.nvim (for running tests only)

## Common Tasks

### Adding a New Configuration Option

1. Add default value to `config.lua` config table
2. Add `@field` annotation to `Configuration` class
3. Use in `terminal.lua` with fallback: `opts.newopt or config.newopt`
4. Update README.md documentation

### Adding a New Public API Function

1. Implement in `init.lua`
2. Add LuaDoc annotations
3. Add tests in `tests/floaterm/floaterm_spec.lua`
4. Document in README.md API section

### Debugging

Enable logging:
```lua
require("floaterm.log").enable = true
```

Logs appear via `vim.notify` with "Floaterm" title.
