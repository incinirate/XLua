local util = {}

local floor = math.floor

function util.shallow(t)
  local c = {}

  for k, v in pairs(t) do
    c[k] = v
  end

  return c
end

function util.inBox(x, y, p1, p2, p3, p4, p5)
  if p1 == false then
    -- width height
    local sx, sy, w, h = p2, p3, p4, p5
    if x >= sx and x < sx + w and y >= sy and y < sy + h then
      return true
    end

    return false
  else
    -- precise coordinates
    local sx, sy, ex, ey = p2, p3, p4, p5
    if x >= sx and x <= ex and y >= sy and y <= ey then
      return true
    end

    return false
  end
end

function util.clamp(x, a, b)
  return x < a and a or (x > b and b or x)
end

function util.roundPrec(x, p)
  return floor(x / p) * p
end

function util:d(a, b)
  self[a] = self[a] and self[a] or b
end

return util
