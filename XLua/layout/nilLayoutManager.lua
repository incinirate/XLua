-- Allows the user to position the elements themselves

-- Implements the interface so XLua doesnt crash but doesnt actually do any
-- laying out of any of the elements given to it

local manager = {}

function manager.new()
  local t = {}
  setmetatable(t, {__index = manager})

  return t
end

function manager:layout() end

return manager
