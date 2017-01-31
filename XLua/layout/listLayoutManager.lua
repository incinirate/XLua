local util = require("XLua/util")

local manager = {}

manager.d = util.d

function manager.new()
  local t = {}
  setmetatable(t, {__index = manager})

  t:d("columns", {1})

  return t
end

function manager:setColumns(cl)
  self.columns = cl
end

function manager:addColumn(widthperc, index)
  index = index or #self.columns + 1

  local iv = 1 - widthperc

  for i=1, #self.columns do
    self.columns[i] = self.columns[i] * iv
  end

  self.columns[index] = widthperc
end

function manager:layoutInternal(e, parent, y, wm, ewm)
  local wperc = self.columns[wm]
  for i = wm + 1, ewm do
    wperc = wperc + self.columns[i]
  end

  local pad = 0
  for i=1, wm - 1 do
    pad = pad + self.columns[i]
  end

  local twid = parent.width - 8

  e.x = 4 + (twid * pad)
  e.y = y
  if e.setWidth then
    e:setWidth(twid * wperc)
  else
    e.width = twid * wperc
  end

  return y + (e.calcHeight and e.calcHeight() or (e.height and e.height or 16))
end

function manager:layout(parent, elements)
  local y = 4

  for i=1, #elements do
    if elements[i].xtype then
      y = self:layoutInternal(elements[i], parent, y, 1, elements[i].stretch) + 2
    else
      local iy = y
      local actCC = 1
      for j=1, #elements[i] do
        if actCC > #self.columns then break end -- Attempting to draw in an unset column
        local cy = self:layoutInternal(elements[i][j], parent, y, actCC, actCC + elements[i][j].stretch - 1)
        iy = cy > iy and cy or iy
        actCC = actCC + elements[i][j].stretch
      end

      y = iy + 2
    end
  end
end

return manager
