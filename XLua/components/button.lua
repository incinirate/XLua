local util = require("XLua/util")

local graphics = love.graphics

local button = {xtype="button"}

button.d = util.d

function button.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = button})

  t:d("label", "")
  t:d("align", "center")

  if t.width then
    t.widthNoResize = true
  else
    t.widthNoResize = false
  end

  t:d("width", 16)
  t:d("height", 16)

  t:d("widthNoResize", t.widthNoResize)

  t:d("stretch", 1)

  t.x = 0
  t.y = 0

  t.highlight = false

  return t
end

function button:colorize(theme)
  self.colorTx = theme.textColorPrimary
  self.colorFAC = theme.accentColor
  self.colorFAS = theme.accentColorSecondary
  self.colorFAA = theme.accentColorAccent
end

function button:mousePressed(x, y, button, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self.focused = true
  end
end

function button:mouseMoved(x, y, button, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self.highlight = true
  else
    self.highlight = false
  end
end

function button:mouseReleased(x, y, button, isTouch)
  self.focused = false
end

function button:draw()
  local fon = graphics.getFont()
  local cHeight = fon:getHeight()

  graphics.setColor(self.focused and self.colorFAS or (self.highlight and self.colorFAA or self.colorFAC))
  graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  graphics.setColor(self.colorTx)

  local midY = self.y + (self.height / 2) - (cHeight / 2)

  if self.align == "left" then
    graphics.print(tostring(self.label), self.x, self.y, midY)
  elseif self.align == "center" then
    local wid = fon:getWidth(tostring(self.label))
    graphics.print(tostring(self.label), self.x + (self.width / 2) - (wid / 2), midY)
  else -- Right align
    local wid = fon:getWidth(tostring(self.label))
    graphics.print(tostring(self.label), self.x + self.width - wid - 1, midY)
  end

  -- graphics.setColor(self.focused and self.colorFAS or (self.highlight and self.colorHl or self.colorFg))
  -- graphics.rectangle("fill", self.x + 1 + self.perc*(self.width - 12), self.y + 1, 10, self.height - 2)
  --
  -- graphics.setColor(self.colorTx)
  -- local text = tostring(self.value) .. self.unit
  -- local tWidth = fon:getWidth(text)
  -- graphics.print(text, self.x + (self.width / 2) - (tWidth / 2), self.y + (self.height / 2) - (cHeight / 2))
end

return button
