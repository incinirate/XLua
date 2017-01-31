local util = require("XLua/util")

local graphics = love.graphics

local checkbox = {xtype="checkbox"}

checkbox.d = util.d

function checkbox.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = checkbox})

  t:d("label", "")
  t:d("align", "center")

  if t.width then
    t.widthNoResize = true
  else
    t.widthNoResize = false
  end

  t:d("width", 16)
  t:d("height", 16)

  t:d("active", false)

  t:d("widthNoResize", t.widthNoResize)

  t:d("stretch", 1)

  t.x = 0
  t.y = 0

  t.highlight = false

  return t
end

function checkbox:colorize(theme)
  self.colorTx = theme.textColorPrimary
  self.colorFAC = theme.actionColorSecondary
  self.colorFAS = theme.actionColorAccent
  self.colorFAA = theme.highlightColor
  self.colorACT = theme.activeColor
end

function checkbox:mousePressed(x, y, checkbox, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self.focused = true
  end
end

function checkbox:mouseMoved(x, y, checkbox, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self.highlight = true
  else
    self.highlight = false
  end
end

function checkbox:mouseReleased(x, y, checkbox, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    self.active = not self.active
  end
  self.focused = false
end

function checkbox:draw()
  local fon = graphics.getFont()
  local cHeight = fon:getHeight()

  graphics.setColor(self.colorFAC)
  graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  if self.focused or self.highlight then
    graphics.setColor(self.focused and self.colorFAS or self.colorFAA)
    graphics.rectangle("line", self.x, self.y, self.width, self.height)
  end

  if self.active then
    graphics.setColor(self.colorACT)
    graphics.rectangle("fill", self.x + 2, self.y + 2, self.width - 4, self.height - 4)
  end
end

return checkbox
