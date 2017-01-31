local util = require("XLua/util")
local listLayoutManager = require("XLua/layout/listLayoutManager")

local window = {}

local graphics = love.graphics
local tableIns = table.insert

window.d = util.d

function window.construct(args)
  local t = args and util.shallow(args) or {}
  setmetatable(t, {__index = window})

  t:d("title", "Untitled")

  t:d("x", 20); t:d("y", 20)
  t:d("width", 600)
  t:d("height", 400)

  t:d("theme", {})
  t.d(t.theme, "backgroundColor", {56, 69, 74, 200}) -- #38454A
  t.d(t.theme, "titleBarColor", {52, 96, 113, 255})

  t.d(t.theme, "textColorPrimary", {255, 255, 255, 170})
  t.d(t.theme, "actionColorPrimary", {50, 96, 115, 200})
  t.d(t.theme, "actionColorSecondary", {51, 86, 100, 200})
  t.d(t.theme, "actionColorAccent", {48, 118, 146, 200})
  t.d(t.theme, "activeColor", {48, 120, 149, 200})
  t.d(t.theme, "highlightColor", {57, 105, 123, 200})
  t.d(t.theme, "accentColor", {118, 82, 83, 200})
  t.d(t.theme, "accentColorSecondary", {106, 74, 75, 200})
  t.d(t.theme, "accentColorAccent", {130, 90, 91, 200}) -- lol

  t:d("layoutManager", listLayoutManager.new())

  t.moving = false
  t.children = {}

  return t
end

function window:draw()
  graphics.push()
  graphics.translate(self.x, self.y)
  do
    graphics.setColor(self.theme.backgroundColor)
    graphics.rectangle("fill", 0, 0, self.width, self.height + 20, 4)

    graphics.setColor(self.theme.titleBarColor)
    graphics.rectangle("fill", 0, 0, self.width, 10, 4)
    graphics.rectangle("fill", 0, 6, self.width, 14, 0)

    graphics.setColor(self.theme.textColorPrimary)
    graphics.print(self.title, 4, 3)

    graphics.push()
    graphics.translate(0, 20)

    for i=1, #self.children do
      if self.children[i].xtype then
        self.children[i]:draw()
      else
        for j=1, #self.children[i] do
          self.children[i][j]:draw()
        end
      end
    end

    graphics.pop()
  end
  graphics.pop()
end

function window:attachChild(childElm)
  if childElm.xtype then
    childElm:colorize(self.theme)
  else
    for i=1, #childElm do
      childElm[i]:colorize(self.theme)
    end
  end
  tableIns(self.children, childElm)
  self.layoutManager:layout(self, self.children)
end

function window:loopChildren(func)
  for i=1, #self.children do
    if self.children[i].xtype then
      func(self.children[i])
    else
      for j=1, #self.children[i] do
        func(self.children[i][j])
      end
    end
  end
end

function window:mousePressed(x, y, button, isTouch)
  if util.inBox(x, y, false, self.x, self.y, self.width, 20) then
    self.moving = true
    self.capturedEvent = true
  elseif util.inBox(x, y, false, self.x, self.y, self.width, self.height + 20) then
    self.capturedEvent = true

    x = x - self.x
    y = y - self.y - 20

    self:loopChildren(function(elm)
      if elm.mousePressed then
        elm:mousePressed(x, y, button, isTouch)
      end
    end)
  else
    self.capturedEvent = false
  end
end

function window:mouseReleased(x, y, button, isTouch)
  self.moving = false
  if util.inBox(x, y, false, self.x, self.y, self.width, self.height + 20) then
    self.capturedEvent = true

    x = x - self.x
    y = y - self.y - 20

    self:loopChildren(function(elm)
      if elm.mouseReleased then
        elm:mouseReleased(x, y, button, isTouch)
      end
    end)
  else
    self.capturedEvent = false
  end
end

function window:mouseMoved(x, y, dx, dy)
  if self.moving then
    self.x = self.x + dx
    self.y = self.y + dy
    self.capturedEvent = true
  elseif util.inBox(x, y, false, self.x, self.y, self.width, self.height + 20) then
    self.capturedEvent = true

    x = x - self.x
    y = y - self.y - 20

    self:loopChildren(function(elm)
      if elm.mouseMoved then
        elm:mouseMoved(x, y, button, isTouch)
      end
    end)
  else
    self.capturedEvent = false
  end
end

function window:keyReleased()
  self.capturedEvent = false
end

function window:keyPressed()
  self.capturedEvent = false
end

return window
