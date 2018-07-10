game              = require "game"
renderer          = require "tools/renderer"
gameLoop          = require "tools/gameLoop"
obm               = require "tools/obm"
asm               = require "tiles/asm"
tlm               = require "tiles/tlm"

local camera      = require "tools/camera"

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()
GAMETIME = 0

function love.load()
  -- first instruction! set low res screen
  game:init()

  asm:load()
  asm:add(love.graphics.newImage("assets/images/tileset.png"), "tiles")

  gameLoop:load()
  renderer:load()
  tlm:load()
  obm:load()

  obm:add(require("objects/player"):new(2*game.sprite,0*game.sprite))
  obm:add(require("objects/opponent"):new(7*game.sprite,0*game.sprite))
end

function love.update(dt)
  gameLoop:update(dt)
  GAMETIME = GAMETIME + dt

--  camera.pos.x = camera.pos.x + math.cos(GAMETIME / 2) * 2
end

function love.draw()
  -- first instruction! scale screen properly
  game:scale()
  camera:set()
  renderer:draw()
  camera:unset()
end
