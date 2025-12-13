local actions = require 'telescope.actions'
local state = require 'telescope.actions.state'
local conf = require 'telescope.config'.values
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local entry_display = require 'telescope.pickers.entry_display'

local tManager = require("floaterm.terminal")

local prepare_results = function(terminals)
  local results = {}
  for id, terminal in pairs(terminals) do
    table.insert(results, {
      id = id,
      cmd = terminal.cmd,
      index = #results + 1,
    })
  end
  return results
end

local generate_new_finder = function()
  return finders.new_table({
    results = prepare_results(tManager.terminals),
    entry_maker = function(entry)
      local displayer = entry_display.create({
        separator = " - ",
        items = {
          { width = 4 },
          { width = 20 },
          { remaining = true },
        },
      })
      local make_display = function()
        return displayer({
          tostring(entry.index),
          entry.id,
          entry.cmd or "shell",
        })
      end
      return {
        value = entry,
        display = make_display,
        ordinal = entry.id,
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
  tManager:delete(floaterm_id)
  actions.close(prompt_bufnr)
end

local toggle_floaterm = function(prompt_bufnr)
  local selection = state.get_selected_entry()
  if not selection then
    return
  end

  local floaterm_id = selection.value.id
  actions.close(prompt_bufnr)
  tManager:toggle(floaterm_id, {})
end

return function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Floaterm",
    finder = generate_new_finder(),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(toggle_floaterm)
      map("i", "<c-d>", delete_floaterm)
      map("n", "<c-d>", delete_floaterm)
      return true
    end,
  }):find()
end
