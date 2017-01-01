local util = require("XLua/util")

local graphics = love.graphics

local slider = {xtype="slider"}

slider.d = util.d

function slider.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = slider})

  t:d("min", 0)
  t:d("max", 100)
  t:d("step", 1)
  t:d("unit", "%")
  t:d("value", 50)
  t.perc = (t.value - t.min) / (t.max - t.min)

  t:d("height", 16)

  t:d("stretch", 1)

  t.x = 0
  t.y = 0

  return t
end

function slider:colorize(theme)
  self.colorBg = theme.actionColorSecondary
  self.colorFg = theme.actionColorPrimary
  self.colorAc = theme.actionColorAccent
  self.colorTx = theme.textColorPrimary
end

function slider:updateVal(x)
  local perc = (x - 12) / (self.width - 12)
  perc = util.clamp(perc, 0, 1)

  local newval = (self.max - self.min)*perc + self.min
  self.value = util.roundPrec(newval, self.step)
  self.perc = perc
end

function slider:mousePressed(x, y, button, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self:updateVal(x)
    self.focused = true
  end
end

function slider:mouseMoved(x, y, button, isTouch)
  if self.focused then
    self:updateVal(x)
  end
end

function slider:mouseReleased(x, y, button, isTouch)
  self.focused = false
end

function slider:draw()
  local fon = graphics.getFont()
  local cHeight = fon:getHeight()

  graphics.setColor(self.colorBg)
  graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  graphics.setColor(self.focused and self.colorAc or self.colorFg)
  graphics.rectangle("fill", self.x + 1 + self.perc*(self.width - 12), self.y + 1, 10, self.height - 2)

  graphics.setColor(self.colorTx)
  local text = tostring(self.value) .. self.unit
  local tWidth = fon:getWidth(text)
  graphics.print(text, self.x + (self.width / 2) - (tWidth / 2), self.y + (self.height / 2) - (cHeight / 2))
end

return slider
