local WorldManager = require("src.worldManager")
local Sensor = {}
Sensor.__index = Sensor

function Sensor:new(tileSize, tileX, tileY)
    local sensor = setmetatable({}, Sensor)
    sensor.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    sensor.y = (tileSize * (tileY - 1)) + (tileSize / 2)
    sensor.body = love.physics.newBody(WorldManager:getWorld(), sensor.x, sensor.y, "static")
    sensor.shape = love.physics.newRectangleShape(tileSize, tileSize)
    sensor.fixture = love.physics.newFixture(sensor.body, sensor.shape)
    sensor.fixture:setSensor(true)
    sensor.fixture:setUserData(sensor)
    sensor.type = "Sensor"
    sensor.colour = { r = 1, g = 0, b = 0, a = 0.5 }
    WorldManager:registerCollisionCallback(sensor.fixture,
        { owner = sensor, beginContact = sensor.beginContact, endContact = sensor.endContact })
    return sensor
end

function Sensor:beginContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Player" or otherUserData.type == "Ghost") then
        self.colour.b = 1
    end
end

function Sensor:endContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Player" or otherUserData.type == "Ghost") then
        self.colour.b = 0
    end
end

function Sensor:draw()
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.setColor(1, 1, 1, 1)
end

return Sensor
