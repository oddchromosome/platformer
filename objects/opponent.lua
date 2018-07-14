game              = require "game"
camera            = require "tools/camera"
physics           = require "tools/physics"
rect              = require "objects/rect"
world_physics     = require "world_physics/world_physics"

local ss = game.sprite
local lg = love.graphics
local key = love.keyboard.isDown

local Opponent = {}

function Opponent:new(x,y)
  local opponent = require("objects/entity"):new(x, y, ss, ss, "opponent")

  function opponent:load()
    gameLoop:addLoop(self)
    renderer:addRenderer(self)

    init_physics(self, 150)
  end

  function opponent:tick(dt)
    -- apply gravity
    apply_gravity(self,dt)

    local player = obm:get_obj_by_id(self, "player")
--    if self.on_ground then
      if self.pos.x < player.pos.x then
        self.vel.x = 20
      else
        self.vel.x = -20
      end
--    end

    -- update physics
    update_physics(self,dt)

    local grid_x, grid_y = game:get_cell(self.pos.x), game:get_cell(self.pos.y)
    if tlm:is_solid_at_pos(grid_x-1,grid_y) or
       tlm:is_solid_at_pos(grid_x+1,grid_y) or
       not tlm:is_solid_at_pos(grid_x-2,grid_y+1) or
       not tlm:is_solid_at_pos(grid_x+2,grid_y+1) then

      jump_physics(self)
    end

    self.pos.x = self.pos.x + self.vel.x * dt
    self.pos.y = self.pos.y + self.vel.y * dt

    self.vel.x = self.vel.x * (1 - dt*12)
  end

  function opponent:draw()
    lg.setColor(0,0,255)
    lg.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
    lg.setColor(255,255,255)
  end

  return opponent
end


return Opponent
