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

local gslid = x.slider.new({value=1, min=-1, max=1, step=.01})
win:attachChild({
  gslid,
  x.blank.new({}),
  x.label.new({text="Gravity"})
})

win:attachChild({
  x.slider.new({max=359, unit=" deg"}),
  x.blank.new({}),
  x.label.new({text="More Slider"})
})

local fr = x.flexRow.new({})

fr:attachChild(x.slider.new({value=70, max=100, step=1, disabled = true}))
fr:attachChild(x.button.new({width=16, label="-"}))
fr:attachChild(x.button.new({width=16, label="+"}))

win:attachChild(fr)

local fr2 = x.flexRow.new({pad = 4})

local chk = x.checkbox.new({width=16, active = true})
fr2:attachChild(chk)
fr2:attachChild(x.label.new({text="Shader pass"}))

win:attachChild(fr2)

return {{
  win
}, {
  gslid,
  chk
}}
