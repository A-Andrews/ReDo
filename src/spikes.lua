local WorldManager = require("src.worldManager")
local Spikes = {}
Spikes.__index = Spikes
local sprite = love.graphics.newImage("images/spikes.png")

function Spikes:new(tileSize, tileX, tileY)
    local spikes = setmetatable({}, Spikes)
    spikes.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    spikes.y = (tileSize * (tileY - 1)) + (tileSize / 2)

    spikes.sprite = sprite

    spikes.body = love.physics.newBody(WorldManager:getWorld(), spikes.x, spikes.y, "static")
    spikes.shape = love.physics.newRectangleShape(tileSize, tileSize - 10)
    spikes.fixture = love.physics.newFixture(spikes.body, spikes.shape)
    spikes.fixture:setSensor(true)
    spikes.fixture:setUserData(spikes)
    spikes.type = "Spikes"
    WorldManager:registerCollisionCallback(spikes.fixture,
        { owner = spikes, beginContact = spikes.beginContact, endContact = spikes.endContact })
    return spikes
end

function Spikes:beginContact(other, coll)

end

function Spikes:endContact(other, coll)

end

function Spikes:draw()
    love.graphics.setColor(1, 1, 1, 1)
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()

    love.graphics.draw(self.sprite, x, y, angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Spikes
