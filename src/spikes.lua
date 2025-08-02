local WorldManager = require("src.worldManager")
local Spikes = {}
Spikes.__index = Spikes

function Spikes:new(tileSize, tileX, tileY)
    local spikes = setmetatable({}, Spikes)
    spikes.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    spikes.y = (tileSize * (tileY - 1)) + (tileSize / 2)
    spikes.body = love.physics.newBody(WorldManager:getWorld(), spikes.x, spikes.y, "static")
    spikes.shape = love.physics.newRectangleShape(tileSize, tileSize)
    spikes.fixture = love.physics.newFixture(spikes.body, spikes.shape)
    spikes.fixture:setSensor(true)
    spikes.fixture:setUserData(spikes)
    spikes.type = "Spikes"
    spikes.colour = { r = 1, g = 1, b = 0, a = 0.5 }
    WorldManager:registerCollisionCallback(spikes.fixture,
        { owner = spikes, beginContact = spikes.beginContact, endContact = spikes.endContact })
    return spikes
end

function Spikes:beginContact(other, coll)
    
end

function Spikes:endContact(other, coll)

end

function Spikes:draw()
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1, 1)
end

return Spikes
