game              = require "game"
tile              = require("tiles/tile")
asm               = require("tiles/asm")

local tileMap     = require("tiles/tileMap")

local Tlm = {}

local lg = love.graphics
local quad = lg.newQuad
local quads =
{
  quad(0,0,8,8,24,8),--bg
  quad(8,0,8,8,24,8),--ground
  quad(16,0,8,8,24,8)--player
}

function gen_quads()
  local tile_width = 3
  local tile_height = 1

  local j = 1
  for i = 1,tile_width do
    quads[i] = quad((i-1) * game.sprite,(j-1) * game.sprite, game.sprite, game.sprite, tile_width * game.sprite, tile_height * game.sprite)
  end
end

function Tlm:load()
  self.img = asm:get("tiles")
  self.tileMap = tileMap
  renderer:addRenderer(self)
  self:loadmap("level_1")
  --gen_quads()
end

function Tlm:loadmap(mapname)
  local map = require("assets/maps/"..mapname)
  self.tileMap:init(map.layers,map.height)

  for layer = 1,#map.layers do
    local data = map.layers[layer].data
    local prop = map.layers[layer].properties
    local layer_name = map.layers[layer].name

    for y = 1,map.height do
      for x = 1,map.width do
        local index = (y-1) * map.width + x

        if data[index] ~= 0 then
          local q = quads[data[index]]
          local t = tile:create(game.sprite * (x - 1), game.sprite * (y - 1), game.sprite, game.sprite, q, data[index])
          self.tileMap:insert(layer_name, y, x, t)
        end
      end
    end
  end
end

function Tlm:is_solid_at_pos(x,y)
  return self.tileMap:get("tiles-solid",y,x) ~= nill
end

function Tlm:draw()
  tileMap:iterate_tiles(
    function(tile)
      lg.draw(self.img,tile.quad,tile.pos.x,tile.pos.y)
    end
  )
end
-- backup
--  for layer,map in pairs(self.tileMap.tiles) do
--    for row=1,#map do
--      for _,tile in pairs(map[row]) do
--        lg.draw(self.img,tile.quad,tile.pos.x,tile.pos.y)
--      end
--    end
--  end

function Tlm:destroy()

end

return Tlm
