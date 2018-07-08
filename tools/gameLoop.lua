local GameLoop = {}

function GameLoop:load()
  self.tickers = {}
end

function GameLoop:addLoop(obj)
  table.insert(self.tickers, obj)
end

function GameLoop:update(dt)
  for ticker = 1, #self.tickers do
    local obj = self.tickers[ticker]
    if obj ~= nil then
      obj:tick(dt)
    end
  end
end

return GameLoop
