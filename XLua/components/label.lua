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
  t:d("valign", "center")
  t:d("stretch", 1)
  t:d("height", 16)
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
  local fHeight = fon:getHeight()

  graphics.setColor(self.color)

  local yPt =
    self.valign=="top" and self.y or
    (self.valign=="center" and self.y + (self.height / 2) - (fHeight / 2) or
    (self.y + self.height - fHeight))

  if self.align == "left" then
    graphics.print(tostring(self.text), self.x, yPt)
  elseif self.align == "center" then
    local wid = fon:getWidth(tostring(self.text))
    graphics.print(tostring(self.text), self.x + (self.width / 2) - (wid / 2), yPt)
  else -- Right align
    local wid = fon:getWidth(tostring(self.text))
    graphics.print(tostring(self.text), self.x + self.width - wid - 1, yPt)
  end
end

return label
