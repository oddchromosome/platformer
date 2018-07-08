local Renderer = {}

local n_layers = 5

function Renderer:load()
  self.drawers = {}
  for i = 1,n_layers do
    self.drawers[i] = {}
  end
end

function Renderer:addRenderer(obj, layer)
  local l = layer or 1
  table.insert(self.drawers[l], obj)
end

function Renderer:draw()
  for layer = 1, #self.drawers do
    for draw = 1, #self.drawers[layer] do
      local obj = self.drawers[layer][draw]
      if obj ~= nil then
        obj:draw()
      end
    end
  end
end

return Renderer
