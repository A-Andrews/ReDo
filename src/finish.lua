local finishFactory = function(tileSize, tileX, tileY)
  local finish = {}

  function finish:load()
    self.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    self.y = (tileSize * (tileY - 1)) + (tileSize / 2)
    self.type = "Finish"
    self.sprite = love.graphics.newImage("images/goal.png")
  end

  function finish:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, nil, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
  end

  return finish
end

return finishFactory
