vec2 = require "objects/vec2"

local camera =
{
  pos = vec2:new(0,0),
  size = vec2:new(0,0),
  scale = vec2:new(1,1),
  rot = 0
}

local lg          = love.graphics
local pop         = lg.pop
local translate   = lg.translate
local rotate      = lg.rotate
local scale       = lg.scale
local push        = lg.push

function camera:set()
  push()
  translate(-self.pos.x, -self.pos.y)
  rotate(-self.rot)
  scale(1 / self.scale.x, 1 / self.scale.y)
end

function camera:goto_point(pos)
  self.pos.x, self.pos.y = pos.x / self.scale.x - WIDTH / 2, pos.y / self.scale.y - HEIGHT / 2
end

function camera:unset()
  pop()
end

return camera
