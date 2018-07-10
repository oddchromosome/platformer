game              = require "game"
camera            = require "tools/camera"
physics           = require "tools/physics"
rect              = require "objects/rect"
world_physics     = require "world_physics/world_physics"

local ss = game.sprite
local lg = love.graphics
local key = love.keyboard.isDown

local Player = {}

function Player:new(x,y)
  local player = require("objects/entity"):new(x, y, ss, ss, nil, nil, "player")

  function player:load()
    gameLoop:addLoop(self)
    renderer:addRenderer(self)

    init_physics(self, 150)
  end

  function player:tick(dt)

    camera:goto_point(self.pos)

    -- apply gravity
    apply_gravity(self,dt)

    if key("left") then
      self.dir.x = -1
      self.vel.x = 50
    end

    if key("right") then
      self.dir.x = 1
      self.vel.x = 50
    end

    -- update physics
    update_physics(self,dt)

    if key("up") then
      jump_physics(self)
    end

    self.pos.x = self.pos.x + (self.vel.x * dt) * self.dir.x
    self.pos.y = self.pos.y + (self.vel.y * dt) * self.dir.y

    self.vel.x = self.vel.x * (1 - dt*12)
  end

  function player:draw()
    lg.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
  end

  return player
end

return Player
