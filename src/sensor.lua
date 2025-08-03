local WorldManager = require("src.worldManager")
local Sensor = {}
Sensor.__index = Sensor

function Sensor:new(tileSize, tileX, tileY)
    local sensor = setmetatable({}, Sensor)
    sensor.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    sensor.y = (tileSize * (tileY - 1)) + (tileSize / 2)

    sensor.spriteActivated = love.graphics.newImage("images/sensor_activated.png")
    sensor.spriteDeactivated = love.graphics.newImage("images/sensor_deactivated.png")
    sensor.activated = false
    sensor.sprite = sensor.spriteDeactivated

    sensor.body = love.physics.newBody(WorldManager:getWorld(), sensor.x, sensor.y, "static")
    sensor.shape = love.physics.newRectangleShape(tileSize, tileSize)
    sensor.fixture = love.physics.newFixture(sensor.body, sensor.shape)
    sensor.fixture:setSensor(true)
    sensor.fixture:setUserData(sensor)
    sensor.type = "Sensor"
    WorldManager:registerCollisionCallback(sensor.fixture,
        { owner = sensor, beginContact = sensor.beginContact, endContact = sensor.endContact })
    return sensor
end

function Sensor:beginContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Player" or otherUserData.type == "Ghost") then
        self.activated = true
        self.sprite = self.spriteActivated
    end
end

function Sensor:endContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (
            otherUserData.type == "Player" or
            (otherUserData.type == "Ghost" and otherUserData.physicsEntity.box:getType() == "dynamic")
        ) then
        self.activated = false
        self.sprite = self.spriteDeactivated
    end
end

function Sensor:update(dt, fixtures)
    return
end

function Sensor:draw()
    love.graphics.setColor(1, 1, 1, 1)
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    love.graphics.draw(self.sprite, x, y, angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Sensor
