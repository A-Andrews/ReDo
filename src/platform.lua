local WorldManager = require("src.worldManager")
local CollisionCategories = require("src.collisionCategories")
local Platform = {}

function Platform:load()
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    self.x = 0
    self.y = self.height / 2
    self.body = love.physics.newBody(WorldManager:getWorld(), self.x + self.width / 2, self.y + self.height / 2, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.type = "Platform"
    self.fixture:setUserData(self)
    WorldManager:registerCollisionCallback(self.fixture, { owner = self, beginContact = self.beginContact, endContact = self
    .endContact })

    self.fixture:setCategory(CollisionCategories.PLATFORM)

end

function Platform:beginContact(other, coll)

end

function Platform:endContact(other, coll)
end

function Platform:update(dt)
    -- Update logic for the platform can be added here if needed
end

function Platform:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

return Platform
