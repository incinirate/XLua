local util = require("XLua/util")

local graphics = love.graphics

local tostring = tostring
local graphics = love.graphics
local tableIns = table.insert

local flexRow = {xtype="flexRow"}

flexRow.d = util.d

function flexRow.new(args)
  local t = util.shallow(args)
  setmetatable(t, {__index = flexRow})

  t:d("children", {})
  t:d("height", 16)
  t:d("pad", 2)

  t.width = 0
  t.x = 0
  t.y = 0

  t:d("stretch", 1)

  return t
end

function flexRow:attachChild(childElm)
  if childElm.xtype then
    tableIns(self.children, childElm)
    self:layout(self, self.children)
  else
    error("flexRow only supports direct children")
  end
end

function flexRow:loopChildren(func)
  for i=1, #self.children do
    func(self.children[i])
  end
end

function flexRow:colorize(theme)
  self:loopChildren(function(childElm)
    childElm:colorize(theme)
  end)
end

function flexRow:layout()
  local fixedspace = 0
  local numFlex = 0

  for i=1, #self.children do
    if self.children[i].widthNoResize then
      fixedspace = fixedspace + self.children[i].width
    else
      numFlex = numFlex + 1
    end
  end

  local cx = 0
  local w = ((self.width - fixedspace - (#self.children - 1)*self.pad) / numFlex)
  for i=1, #self.children do
    local wi = w
    if self.children[i].widthNoResize then
      wi = self.children[i].width
    else
      self.children[i].width = wi
    end

    self.children[i].x = self.x + cx + (i - 1)*self.pad
    self.children[i].y = self.y

    cx = cx + wi
  end
end

function flexRow:setWidth(nwid)
  self.width = nwid
  self:layout()
end

function flexRow:draw()
  for i=1, #self.children do
      self.children[i]:draw()
  end
end


function flexRow:mousePressed(x, y, button, isTouch)
  -- if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    -- self.capturedEvent = true

    -- x = x - self.x
    -- y = y - self.y

    self:loopChildren(function(elm)
      if elm.mousePressed then
        elm:mousePressed(x, y, button, isTouch)
      end
    end)
  -- else
    -- self.capturedEvent = false
  -- end
end

function flexRow:mouseReleased(x, y, button, isTouch)
  -- if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    -- self.capturedEvent = true

    -- x = x - self.x
    -- y = y - self.y

    self:loopChildren(function(elm)
      if elm.mouseReleased then
        elm:mouseReleased(x, y, button, isTouch)
      end
    end)
  -- else
    -- self.capturedEvent = false
  -- end
end

function flexRow:mouseMoved(x, y, dx, dy)
  -- if util.inBox(x, y, false, self.x, self.y, self.width, self.height) then
    -- print("Hey")
    -- self.capturedEvent = true

    -- x = x - self.x
    -- y = y - self.y

    self:loopChildren(function(elm)
      if elm.mouseMoved then
        elm:mouseMoved(x, y, button, isTouch)
      end
    end)
  -- else
    -- self.capturedEvent = false
  -- end
end

return flexRow
