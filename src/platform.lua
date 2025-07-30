local Platform = {}

function Platform:load()
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    self.x = 0
    self.y = self.height / 2
end

function Platform:update(dt)
    -- Update logic for the platform can be added here if needed
end

function Platform:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Platform
