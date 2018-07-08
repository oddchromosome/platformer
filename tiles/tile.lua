vec2              = require("objects/vec2")

local Tile = {}

function Tile:create(x,y,w,h,quad,index)
  local tile = {}

  tile.pos = vec2:new(x, y)
  tile.size = vec2:new(w, h)
  tile.quad = quad
  tile.index = index

  return tile
end

return Tile
