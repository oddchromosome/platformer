game              = require "game"

function collision_suspect(moving)
  local suspects = {}

  local x, y = game:get_cell(moving.pos.x), game:get_cell(moving.pos.y)

  if moving.dir.x > 0 then
    table.insert(suspects, {x+1,  y-1})
    table.insert(suspects, {x+1,  y})
    table.insert(suspects, {x+1,  y+1})
  elseif moving.dir.x < 0 then
    table.insert(suspects, {x-1,  y-1})
    table.insert(suspects, {x-1,  y})
    table.insert(suspects, {x-1,  y+1})
  end

  if moving.dir.y > 0 then
    table.insert(suspects, {x-1,y+1})
    table.insert(suspects, {x,  y+1})
    table.insert(suspects, {x+1,y+1})
  elseif moving.dir.y < 0 then
    table.insert(suspects, {x-1,y-1})
    table.insert(suspects, {x,  y-1})
    table.insert(suspects, {x+1,y-1})
  end

  return suspects
end

function rectangle_collision(rect_1, rect_2)
  collisions = {}
  if collision_right(rect_1,rect_2) then
    table.insert(collisions, "right")
  end
  if collision_left(rect_1,rect_2) then
    table.insert(collisions, "left")
  end
  if collision_up(rect_1,rect_2) then
    table.insert(collisions, "up")
  end
  if collision_down(rect_1,rect_2) then
    table.insert(collisions, "down")
  end
  
  return collisions
end

function collision_right(rect_1,rect_2)
  -- right
  if rect_1.pos.x + rect_1.size.x > rect_2.pos.x and
     rect_1.pos.x + rect_1.size.x < rect_2.pos.x + rect_2.size.x/2 and
     rect_1.pos.y + rect_1.size.y > rect_2.pos.y and
     rect_1.pos.y < rect_2.pos.y + rect_2.size.y then

    snap_right(rect_1,rect_2)
    return true
  end

  return false
end

function collision_left(rect_1,rect_2)
  -- left
  if rect_1.pos.x < rect_2.pos.x + rect_2.size.x and
     rect_1.pos.x > rect_2.pos.x + rect_2.size.x/2 and
     rect_1.pos.y + rect_1.size.y > rect_2.pos.y and
     rect_1.pos.y < rect_2.pos.y + rect_2.size.y then

    snap_left(rect_1,rect_2)
    return true
  end

  return false
end

function collision_up(rect_1,rect_2)
  -- up
  if rect_1.pos.y + rect_1.size.y > rect_2.pos.y and
     rect_1.pos.y + rect_1.size.y < rect_2.pos.y + rect_2.size.y/2 and
     rect_1.pos.x + rect_1.size.x > rect_2.pos.x and
     rect_1.pos.x < rect_2.pos.x + rect_2.size.x then

    snap_up(rect_1,rect_2)
    return true
  end

  return false
end

function collision_down(rect_1,rect_2)
  -- down
  if rect_1.pos.y < rect_2.pos.y + rect_2.size.y and
     rect_1.pos.y > rect_2.pos.y + rect_2.size.y/2 and
     rect_1.pos.x + rect_1.size.x > rect_2.pos.x and
     rect_1.pos.x < rect_2.pos.x + rect_2.size.x then

    snap_down(rect_1,rect_2)
    return true
  end

  return false
end

function snap_up(moving,static)
  moving.pos.y = static.pos.y - moving.size.y
end

function snap_down(moving,static)
  moving.pos.y = static.pos.y + static.size.y
end

function snap_right(moving,static)
  moving.pos.x = static.pos.x - moving.size.x
end

function snap_left(moving,static)
  moving.pos.x = static.pos.x + static.size.x
end
