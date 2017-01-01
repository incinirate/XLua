local x = require("XLua/x")

local win = x.window.construct({
  title = "Test Window",
  width = 250,
  height = 100,
  x = 650,
  y = 30
})

win.layoutManager:addColumn(0.1) -- Seperator column
win.layoutManager:addColumn(0.3) -- Add new column of 30% width

local sepLabel = x.label.new({text="Test label", align="center"})
sepLabel.stretch = 3
win:attachChild(sepLabel)

win:attachChild({
  x.slider.new({value=70}),
  x.blank.new({}),
  x.label.new({text="Test Slider"})
})

win:attachChild({
  x.slider.new({max=359, unit=" deg"}),
  x.blank.new({}),
  x.label.new({text="More Slider"})
})

return {
  win
}
