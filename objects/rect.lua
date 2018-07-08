local vec2 = require "objects/vec2"

local Rect = {}

function Rect:new(x,y,w,h)
  local rect = {}

  rect.pos = vec2:new(x,y)
  rect.size = vec2:new(w,h)

  return rect
end

return Rect
