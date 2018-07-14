game              = require "game"
rect              = require "objects/rect"
vec2              = require "objects/vec2"

local tile_layer  = "tiles-solid"
local tileMap     = tlm.tileMap

function init_physics(obj,gravity)
  obj.on_ground  = false
  obj.gravity    = gravity or 125
end

function jump_physics(obj)
  if obj.vel.y < 10 and obj.vel.y > -10 and obj.on_ground then
    obj.vel.y = -obj.gravity * .6
    obj.on_ground = false
  end
end

function apply_gravity(obj,dt)
  obj.vel.y = obj.vel.y + obj.gravity * dt
  obj.dir.y = 1
end

function update_physics(obj,dt)
  -- collisions
  local x, y = game:get_cell(obj.pos.x), game:get_cell(obj.pos.y)
  local d = 1

  for i = y-d,y+d do
    for j = x-d,x+d do
      local tile = tileMap:get(tile_layer,i,j)
      if tile == nil then goto cont end

      local box = rect:new(obj.pos.x + obj.vel.x * dt * obj.dir.x,obj.pos.y + obj.vel.y * dt * obj.dir.y,obj.size.x,obj.size.y)

      local coll,rect = rectangle_collision(box, tile)
      if coll then
        obj.vel.y = 0
        obj.dir.y = 0

        -- y collisions
        if obj.pos.y + obj.size.y / 2 < rect.pos.y + rect.size.y / 2 then

          -- fix bounds
          if box.pos.y + box.size.y > rect.pos.y and
             obj.pos.y + obj.size.y < rect.pos.y + game.sprite / 2 then

            obj.on_ground = true
            obj.pos.y = rect.pos.y - obj.size.y
          end
        else
          if obj.pos.y > rect.pos.y + rect.size.y - game.sprite / 2 then
            obj.vel.y = 0
            obj.pos.y = rect.pos.y + rect.size.y

            goto skip_x
          end
          -- goto cont
        end

        -- x collisions
        if obj.pos.x + obj.size.x/2 < rect.pos.x + rect.size.x/2 then

          --fix bounds left
          if box.pos.x + box.size.x > rect.pos.x and
             obj.pos.y + obj.size.y > rect.pos.y then

            obj.vel.x = 0
            obj.dir.x = 0

            obj.pos.x = rect.pos.x - rect.size.x
          end
        else
          --fix bounds right
          if box.pos.x < rect.pos.x + rect.size.x and
             obj.pos.y + obj.size.y > rect.pos.y then

            obj.vel.x = 0
            obj.dir.x = 0

            obj.pos.x = rect.pos.x + rect.size.x
          end
        end
        ::skip_x::
      end
      ::cont::
    end
  end
end
