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

    if not self.on_ground then
      self.dir.y = 1
      self.vel.y = self.vel.y + self.gravity * dt
    else
      self.dir.y = 0
      self.vel.y = 0
    end

    if key("left") then
      self.dir.x = -1
      self.vel.x = 50
    end

    if key("right") then
      self.dir.x = 1
      self.vel.x = 50
    end

    local delta_x,delta_y = 0,0

    -- x velocity
    delta_x = self.vel.x * dt * self.dir.x
    self.pos.x = self.pos.x + delta_x

    if not self.on_ground then
      delta_y = self.vel.y * dt * self.dir.y
      self.pos.y = self.pos.y + delta_y
    end

    -- jump
    if key("up") then
      self.on_ground = false
      if self.vel.y < 10 and self.vel.y > -10 then
        self.dir.y = -1
        self.vel.y = self.dir.y * self.gravity * .5
      end
    end

    -- collisions
    local suspect_coordinates = collision_suspect(self)
    if suspect_coordinates then
      for i = 1,#suspect_coordinates do
        local point = suspect_coordinates[i]
        local tile = tileMap:get(tile_layer,point[2],point[1])
        if tile ~= nil then
          local collisions = rectangle_collision(self, tile, delta_x, delta_y)
          for c = 1,#collisions do
            if collisions[c] == "up" or collisions[c] == "down" then
              self.vel.y = 0
              self.dir.y = 0
              if collisions[c] == "down" then
                self.on_ground = true
              end
            elseif collisions[c] == "right" or collisions[c] == "left" then
              self.vel.x = 0
              self.dir.x = 0
            end
          end
        end
      end
    end

    self.vel.x = self.vel.x * (1 - dt*12)
  end

  function player:draw()
    lg.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
  end

  return player
end

return Player
