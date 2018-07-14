game              = require "game"
camera            = require "tools/camera"
physics           = require "tools/physics"
rect              = require "objects/rect"
world_physics     = require "world_physics/world_physics"

local ss = game.sprite
local lg = love.graphics
local key = love.keyboard.isDown

local quad = love.graphics.newQuad
local animation_data = {
  quad(0,0,8,8,24,8),
  quad(8,0,8,8,24,8),
  quad(16,0,8,8,24,8)
}
local image = love.graphics.newImage("assets/images/player-tiles.png")

local Player = {}

function Player:new(x,y)
  local player = require("objects/entity"):new(x, y, ss, ss, nil, nil, "player")

  function player:load()
    gameLoop:addLoop(self)
    renderer:addRenderer(self)

    init_physics(self, 150)

    self.animation = require("tools/animation"):new(
      image,
      {
        {
          animation_data[3]
        },
        {
          animation_data[1],
          animation_data[2],
          animation_data[1]
        },
        0.2
      }
    )

    self.animation:play()
  end

  function player:tick(dt)

    camera:goto_point(self.pos)

    self.animation:set_animation(1)

    -- apply gravity
    apply_gravity(self,dt)

    if key("left") then
      self.animation:set_animation(2)
      self.dir.x = -1
      self.vel.x = 50
    end

    if key("right") then
      self.animation:set_animation(2)
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

    self.animation:update(dt)
  end

  function player:draw()
    self.animation:draw({self.pos.x, self.pos.y})
    --lg.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
  end

  return player
end

return Player
