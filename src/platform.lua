local WorldManager = require("src.worldManager")
local Platform = {}

function Platform:load()
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    self.x = 0
    self.y = self.height / 2
    self.body = love.physics.newBody(WorldManager:getWorld(), self.x + self.width / 2, self.y + self.height / 2, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Platform:update(dt)
    -- Update logic for the platform can be added here if needed
end

function Platform:draw()
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(0.5, 0.5, 0.5) -- Gray color for the platform
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

return Platform
