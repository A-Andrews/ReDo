local WorldManager = require("src.worldManager")
local MovingPlatform = {}
MovingPlatform.__index = MovingPlatform
local sprite = love.graphics.newImage("images/moving_platform.png")

function MovingPlatform:new(tileSize, tileX, tileY)
    local movingPlatform = setmetatable({}, MovingPlatform)

    movingPlatform.startX = (tileSize * (tileX - 1)) + (tileSize / 2)
    movingPlatform.startY = (tileSize * (tileY - 1)) + (tileSize / 2)

    movingPlatform.sprite = sprite

    movingPlatform.speed = 500
    movingPlatform.distance = tileSize * 2
    movingPlatform.elapsedTime = 0
    movingPlatform.body = love.physics.newBody(WorldManager:getWorld(), movingPlatform.startX, movingPlatform.startY,
        "kinematic")
    movingPlatform.shape = love.physics.newRectangleShape(tileSize, tileSize / 2)
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

function MovingPlatform:update(dt, time)
    self.elapsedTime = time + dt
    local offset = math.sin(self.elapsedTime * 2 * math.pi / 2) * (self.distance / 2)
    self.body:setPosition(self.startX + offset, self.startY)
end

function MovingPlatform:draw()
    love.graphics.setColor(1, 1, 1, 1)
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()

    love.graphics.draw(self.sprite, x, y, angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return MovingPlatform
