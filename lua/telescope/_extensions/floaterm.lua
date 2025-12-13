local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("floaterm.nvim requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
  exports = {
    floaterm = require("telescope._extensions.floaterm_builtin"),
  },
})
