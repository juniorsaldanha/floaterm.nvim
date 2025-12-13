# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

floaterm.nvim is a Neovim plugin that provides floating terminal windows. It allows multiple independent terminal instances with customizable size, borders, and keybindings.

## Commands

### Running Tests
```bash
make test
```
Tests use plenary.nvim's busted testing framework. Test files are in `tests/` and follow the `*_spec.lua` naming convention.

### Manual Testing
```bash
make nvim_minimal
```
Opens Neovim with minimal config. Use `:FloatermStart` command to load the plugin with sample terminals.

## Architecture

### Core Modules (`lua/floaterm/`)

- **init.lua** - Public API entry point. Exports `setup()`, `register_terminal()`, `register_app()`, `set_timeout()`, and `list_terminals()`.

- **terminal.lua** - Terminal manager singleton (`TerminalManager`). Handles terminal lifecycle: creation, show/hide toggling, deletion. Manages floating window positioning and buffer creation. Auto-hides terminals on focus loss via `WinEnter` autocmd.

- **config.lua** - Configuration defaults and validation. Settings: `width`, `height`, `border`, `close_all_keymap`, `timeout`, `cmd`.

- **log.lua** - Logging utility (disabled by default). Set `require("floaterm.log").enable = true` to enable.

### Key Concepts

- **Terminal Registration**: `register_terminal(id, lhs, opts)` creates a terminal bound to a keymap. The keymap works in both normal and terminal mode.

- **App Registration**: `register_app(id, lhs, cmd, opts)` wraps `register_terminal` to run a specific command (e.g., lazygit, claude) instead of the default shell.

- **Timeout Management**: The plugin temporarily reduces `timeoutlen` when terminals are visible to make keymaps more responsive, restoring it when hidden.

### Telescope Extension (`lua/telescope/_extensions/`)

Optional integration for listing/managing terminals via Telescope picker. Requires telescope.nvim and nvim-treesitter.

## Plugin Loading

`plugin/load_floaterm.lua` creates the `:FloatermStart` user command for development/testing purposes.
