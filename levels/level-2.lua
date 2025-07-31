local level = {}

function level:load()
  self.ending = love.graphics.newImage("images/end.png")
end

level.endloc = { 500, 300 }

function level:update(dt)
end

function level:draw()
  love.graphics.draw(self.ending, self.endloc[1], self.endloc[2])
end

return level
