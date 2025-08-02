local finishFactory = function(tileSize, tileX, tileY)
  local finish = {}

  function finish:load()
    self.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    self.y = (tileSize * (tileY - 1)) + (tileSize / 2)
    self.type = "Finish"
  end

  function finish:draw()
    love.graphics.setColor(250, 200, 0)
    love.graphics.circle('fill', self.x, self.y, tileSize / 2)
  end

  return finish
end

return finishFactory
