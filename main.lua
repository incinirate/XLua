io.stdout:setvbuf("no")

local x = require("XLua/x")
local demoX = require("demoX")
local demoGame = require("demoGame")

local graphics = love.graphics
local sWidth, sHeight = love.window.getMode()

local mainFont = graphics.newFont("Roboto-Medium.ttf")

function love.load()
  love.window.setIcon(love.image.newImageData("icon.png"))
  graphics.setFont(mainFont)
end

function love.update(dt)
  demoGame.update(dt)
end

function love.draw()
  -- Draw rest of game here
  demoGame.draw()
  -- End game draw

  for i=1, #demoX do
    demoX[i]:draw()
  end
end

function love.mousemoved(x, y, dx, dy)
  for i=1, #demoX do
    demoX[i]:mouseMoved(x, y, dx, dy)

    if demoX[i].capturedEvent then
      return
    end
  end

  -- Pass to rest of game
  demoGame.mouseMoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
  for i=1, #demoX do
    demoX[i]:mousePressed(x, y, button, isTouch)

    if demoX[i].capturedEvent then
      return
    end
  end

  -- Pass to rest of game
  demoGame.mousePressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
  for i=1, #demoX do
    demoX[i]:mouseReleased(x, y, button, isTouch)

    if demoX[i].capturedEvent then
      return
    end
  end

  -- Pass to rest of game
  demoGame.mouseReleased(x, y, button, isTouch)
end

function love.keypressed(key, scancode, isrepeat)
  for i=1, #demoX do
    demoX[i]:keyPressed(key, scancode, isrepeat)

    if demoX[i].capturedEvent then
      return
    end
  end

  -- Pass to rest of game
  demoGame.keyPressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
  for i=1, #demoX do
    demoX[i]:keyReleased(key)

    if demoX[i].capturedEvent then
      return
    end
  end

  -- Pass to rest of game
  demoGame.keyReleased(key)
end
