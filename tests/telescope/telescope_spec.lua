describe("telescope extension", function()
  it("floaterm extension file exists and has correct structure", function()
    -- Read the extension file to verify structure
    local extension_path = "lua/telescope/_extensions/floaterm.lua"
    local file = io.open(extension_path, "r")
    assert(file ~= nil, "floaterm.lua extension file should exist")
    local content = file:read("*all")
    file:close()

    assert(content:find("telescope.register_extension"), "should register telescope extension")
    assert(content:find("floaterm_builtin"), "should reference floaterm_builtin")
  end)

  it("floaterm_builtin file exists and has correct structure", function()
    local builtin_path = "lua/telescope/_extensions/floaterm_builtin.lua"
    local file = io.open(builtin_path, "r")
    assert(file ~= nil, "floaterm_builtin.lua file should exist")
    local content = file:read("*all")
    file:close()

    assert(content:find("entry_display"), "should use entry_display")
    assert(content:find("tManager"), "should use terminal manager")
    assert(content:find("prepare_results"), "should have prepare_results function")
    assert(content:find("generate_new_finder"), "should have generate_new_finder function")
    assert(content:find("delete_floaterm"), "should have delete_floaterm function")
    assert(content:find("toggle_floaterm"), "should have toggle_floaterm function")
    assert(content:find(":find%(%)"), "should call :find() on picker")
  end)

  it("telescope extension loads when telescope is available", function()
    local has_telescope = pcall(require, "telescope")
    if has_telescope then
      local ok, _ = pcall(require, "telescope._extensions.floaterm")
      assert(ok, "floaterm extension should load without error")
    else
      -- Skip test if telescope is not installed
      assert(true, "telescope not available, skipping load test")
    end
  end)
end)
