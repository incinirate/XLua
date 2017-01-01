local window = require("XLua/window")

local blank  = require("XLua/components/blank")
local label  = require("XLua/components/label")
local slider = require("XLua/components/slider")

local listLayoutManager = require("XLua/listLayoutManager")
local nilLayoutManager  = require("XLua/nilLayoutManager")

return {
  window = window,

  blank  = blank,
  label  = label,
  slider = slider,

  listLayoutManager = listLayoutManager,
  nilLayoutManager  = nilLayoutManager
}
