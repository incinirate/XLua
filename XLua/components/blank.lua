local util = require("XLua/util")

local graphics = love.graphics

local tostring = tostring

local label = {xtype="blank"}

label.d = util.d

function label.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = label})

  t:d("stretch", 1)

  return t
end

function label:colorize() end

function label:draw() end

return label
