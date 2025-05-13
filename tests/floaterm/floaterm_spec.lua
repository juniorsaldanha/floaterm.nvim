local plugin = require("floaterm")

describe("setup", function()
  it("works with default", function()
    assert(plugin.setup() == nil, "my first function with no param")
  end)

  it("works with custom var", function()
    assert(plugin.setup({ width = 0.8, height = 0.8 }) == nil, "my first function with custom param")
  end)

  it("does not work with invalid opt", function()
    local status, err = pcall(function()
      plugin.setup({ invalid_opt = "invalid" })
    end)
    assert(not status, "my first function with invalid param")
    assert(err:find("Invalid configuration key"), "Error message should contain 'Invalid configuration key'")
  end)
end)
