local graphics = love.graphics
local sWidth, sHeight = love.window.getMode()

local playerX = 50
local playerY = 40

local playerXVel = 0
local playerXVelGoal = 0
local playerYVel = 0
local playerRunning = false
local playerCrouch = false

local gravity = 9.8 * 100

local abs = math.abs
local floor = math.floor

local canvas = graphics.newCanvas()

local tShader
do
  local content = love.filesystem.read("demoGameTerrainShader_f.glsl")
  tShader = love.graphics.newShader(content)
end

tShader:send("iResolution", {sWidth, sHeight})
tShader:send("lightPos", {20, 40})

local demo = {}

local function grounded()
  local h = 0

  local cond2 = playerY >= sHeight - 360 and playerY < sHeight - 350 and floor(((playerX - 25) / (sWidth / 8)) % 2) == 0
  h = cond2 and sHeight - 360 or h
  local cond1 = playerY >= sHeight - 300
  h = cond1 and sHeight - 300 or h

  return cond1 or cond2, h
end

function demo.update(dt)
  playerX = playerX + playerXVel * dt
  playerY = playerY + playerYVel * dt

  local grnd, h = grounded()
  if grnd then
    playerY = h
    if playerYVel > 0 then
      playerYVel = 0
    end

    -- Movement logic
    playerXVel = playerXVel + (playerXVelGoal - playerXVel)*dt*5

    if abs(playerXVel) > 1 then
      -- Friction
      playerXVel = playerXVel + -playerXVel*dt*2
    else
      playerXVel = 0
    end
  else
    playerYVel = playerYVel + gravity * dt
  end
end

function sceneDraw()
  graphics.setColor(57, 93, 51)
  graphics.rectangle("fill", 0, sHeight - 300, sWidth, 300)
  for i=1, 4 do
    graphics.rectangle("fill", (i - 1) * sWidth / 4 + 25 + 10, sHeight - 360, sWidth / 8 - 10, 10)
  end

  graphics.setColor(200, 30, 10)
  graphics.rectangle("fill", playerX, playerY - (playerCrouch and 15 or 30), 10, playerCrouch and 15 or 30)
end

function demo.draw()
  graphics.setCanvas(canvas)
    graphics.setBlendMode("alpha")
    graphics.clear()
    sceneDraw()
  graphics.setCanvas()

  tShader:send("iChannel0", canvas)

  graphics.setColor(255, 255, 255, 255)
  graphics.setShader(tShader)
  graphics.setBlendMode("alpha", "premultiplied")
  graphics.rectangle("fill", 0, 0, sWidth, sHeight)
  graphics.setBlendMode("alpha")
  graphics.setShader()
end

function demo.keyPressed(k)
  if grounded() then
    if k == "up" then
      playerYVel = -350
    end
  end

  if k == "left" then
    playerXVelGoal = -200
    playerRunning = true
  elseif k == "right" then
    playerXVelGoal = 200
    playerRunning = true
  elseif k == "down" then
    playerCrouch = true
  end
end

function demo.keyReleased(k)
  if k == "left" or k == "right" then
    playerXVelGoal = 0
    playerRunning = false
  elseif k == "down" then
    playerCrouch = false
  end
end

local pressed = false

function demo.mousePressed(x, y, button, isTouch)
  if button == 1 then
    pressed = true
    tShader:send("lightPos", {x, y})
  end
end

function demo.mouseReleased(x, y, button, isTouch)
  if button == 1 then
    pressed = false
  end
end

function demo.mouseMoved(x, y, dx, dy)
  if pressed then
    tShader:send("lightPos", {x, y})
  end
end

return demo
