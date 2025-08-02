local WorldManager = require("src.worldManager")
local MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

function MovingPlatform:new(tileSize, tileX, tileY)
    local movingPlatform = setmetatable({}, MovingPlatform)

    movingPlatform.startX = (tileSize * (tileX - 1)) + (tileSize / 2)
    movingPlatform.startY = (tileSize * (tileY - 1)) + (tileSize / 2)
    movingPlatform.speed = 500
    movingPlatform.distance = tileSize * 2
    movingPlatform.elapsedTime = 0
    movingPlatform.body = love.physics.newBody(WorldManager:getWorld(), movingPlatform.startX, movingPlatform.startY,
        "kinematic")
    movingPlatform.shape = love.physics.newRectangleShape(tileSize, tileSize)
    movingPlatform.fixture = love.physics.newFixture(movingPlatform.body, movingPlatform.shape)
    movingPlatform.fixture:setUserData(movingPlatform)
    movingPlatform.type = "MovingPlatform"
    movingPlatform.colour = { r = 0, g = 0, b = 1, a = 0.5 }
    WorldManager:registerCollisionCallback(movingPlatform.fixture,
        { owner = movingPlatform, beginContact = movingPlatform.beginContact, endContact = movingPlatform.endContact })
    return movingPlatform
end

function MovingPlatform:beginContact(other, coll)
end

function MovingPlatform:endContact(other, coll)
end

function MovingPlatform:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    local offset = math.sin(self.elapsedTime * 2 * math.pi / 2) * (self.distance / 2)
    self.body:setPosition(self.startX + offset, self.startY)
end

function MovingPlatform:draw()
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1, 1)
end

return MovingPlatform
