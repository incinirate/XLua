local util = require("XLua/util")

local graphics = love.graphics

local tostring = tostring

local label = {xtype="label"}

label.d = util.d

function label.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = label})

  t:d("text", "")
  t:d("align", "left")
  t:d("stretch", 1)
  t.x = 0
  t.y = 0
  t.color = {255, 255, 255, 255}

  return t
end

function label:colorize(theme)
  self.color = theme.textColorPrimary
end

function label:draw()
  local fon = graphics.getFont()

  graphics.setColor(self.color)

  if self.align == "left" then
    graphics.print(tostring(self.text), self.x, self.y)
  elseif self.align == "center" then
    local wid = fon:getWidth(tostring(self.text))
    graphics.print(tostring(self.text), self.x + (self.width / 2) - (wid / 2), self.y)
  else -- Right align
    local wid = fon:getWidth(tostring(self.text))
    graphics.print(tostring(self.text), self.x + self.width - wid - 1)
  end
end

return label
