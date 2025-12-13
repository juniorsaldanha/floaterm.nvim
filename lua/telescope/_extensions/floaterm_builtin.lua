local actions = require 'telescope.actions'
local state = require 'telescope.actions.state'
local actions_set = require 'telescope.actions.set'
local conf = require 'telescope.config'.values
local finders = require 'telescope.finders'
local make_entry = require "telescope.make_entry"
local pickers = require 'telescope.pickers'
local ts_utils = require 'nvim-treesitter.ts_utils'
local channel = require("plenary.async.control").channel

local floaterm = require("floaterm")
local floterm_terminal = require("floaterm.terminal")

local prepare_results = function(terminals)
  local results = {}
  for _, terminal in ipairs(terminals) do
    local id = terminal.id
    local buf = terminal.buf
    local win = terminal.win

    if buf and win then
      table.insert(results, {
        id = id,
        index = #results + 1,
      })
    end
  end
  return results
end

local generate_new_finder = function()
  return finders.new_table({
    results = prepare_results(floterm_terminal.terminals),
    entry_maker = function(entry)
      local displayer = entry_display.create({
        separator = " - ",
        items = {
          { width = 2 },
          { width = 50 },
          { remaining = true },
        },
      })
      local make_display = function()
        return displayer({
          tostring(entry.index),
        })
      end
      return {
        value = entry,
        display = make_display,
        id = entry.id,
      }
    end,
  })
end

local delete_floaterm = function(prompt_bufnr)
  local selection = state.get_selected_entry()
  if not selection then
    return
  end

  local floaterm_id = selection.value.id
  local floaterm_instance = floaterm.get(floaterm_id)
  if floaterm_instance then
    floaterm_instance:delete()
  else
    print("Floaterm instance not found")
  end

  actions.close(prompt_bufnr)
end

return function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Floaterm",
    finder = generate_new_finder(),
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function(_, map)
      map("i", "<c-d>", delete_floaterm)
      map("n", "<c-d>", delete_floaterm)
      return true
    end,
  })
end
