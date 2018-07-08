local TileMap = {}

local insert = table.insert

function TileMap:init(layers,rows)
  self.tiles = {}
  for l=1,#layers do
    self.tiles[layers[l].name] = {}
    for r=1,rows do
      self.tiles[layers[l].name][r] = {}
    end
  end
end

function TileMap:insert(layer,row,column,element)
  table.insert(self.tiles[layer][row],column,element)
end

function TileMap:get(layer,row,column)
  return self.tiles[layer][row] ~= nil and self.tiles[layer][row][column] or nil
end

function TileMap:print_tiles()
  print("Tiles:")
  for layer,map in pairs(self.tiles) do
    print("Layer: "..layer)
    for row=1,#map do
      str = ""..row..": "
      for column,element in pairs(map[row]) do
        str = str .."("..column.."," .. element.index..")"
      end
      print(str)
    end
  end
end

function TileMap:iterate_tiles(execute)
  for layer,map in pairs(self.tiles) do
    for row=1,#map do
      for column,element in pairs(map[row]) do
        execute(element)
      end
    end
  end
end

return TileMap
