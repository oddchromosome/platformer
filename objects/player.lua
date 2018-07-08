game              = require "game"
camera            = require "tools/camera"
physics           = require "tools/physics"
rect              = require "objects/rect"

local tile_layer = "tiles-solid"
local tileMap = tlm.tileMap

local ss = game.sprite
local lg = love.graphics
local key = love.keyboard.isDown

local Player = {}

function Player:new(x,y)
  local player = require("objects/entity"):new(x, y, ss, ss, nil, nil, "player")

  function player:load()
    gameLoop:addLoop(self)
    renderer:addRenderer(self)

    self.on_ground = false
    self.gravity = 50
  end

  function player:tick(dt)

    camera:goto_point(self.pos)

    self.vel.y = self.vel.y + self.gravity * dt
    self.dir.y = 1

    -- collisions
    local x, y = game:get_cell(self.pos.x), game:get_cell(self.pos.y)

    local d = 1

    for i = y,y+d do
      for j = x,x+d do
        local tile = tileMap:get(tile_layer,i,j)
        if tile == nil then goto cont end

        local box = rect:new(self.pos.x,self.pos.y,self.size.x, self.size.y)

        local coll,rect = rectangle_collision(box, tile)
        if coll then
          self.vel.y = 0
          self.dir.y = 0

          if self.pos.y + self.size.y > rect.pos.y then
            self.pos.y = rect.pos.y - self.size.y
          end
        end

        ::cont::
      end
    end

    if key("left") then
      self.dir.x = -1
      self.vel.x = 50
    end

    if key("right") then
      self.dir.x = 1
      self.vel.x = 50
    end

    if key("up") then
      if self.vel.y < 10 and self.vel.y > -10 then
        self.vel.y = -self.gravity * .5
      end
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
