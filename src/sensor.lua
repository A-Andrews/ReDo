local WorldManager = require("src.worldManager")
local Sensor = {}
Sensor.__index = Sensor

local spriteActivated = love.graphics.newImage("images/sensor_activated.png")
local spriteDeactivated = love.graphics.newImage("images/sensor_deactivated.png")

function Sensor:new(tileSize, tileX, tileY)
    local sensor = setmetatable({}, Sensor)
    sensor.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    sensor.y = (tileSize * (tileY - 1)) + (tileSize / 2)

    sensor.spriteActivated = spriteActivated
    sensor.spriteDeactivated = spriteDeactivated

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

    sensor.contacts = {}
    return sensor
end

function Sensor:keypressed(key)
    if key == "r" or key == "c" or key == "f" then
        self:reset()
    end
end

function Sensor:reset()
    self.contacts = {}
    self.activated = false
    self.sprite = self.spriteDeactivated
end

function Sensor:beginContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Player" or otherUserData.type == "Ghost") then
        self.contacts[other] = true
        self.activated = true
        self.sprite = self.spriteActivated
    end
end

function Sensor:endContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and self.contacts[other] == true and (
            otherUserData.type == "Player" or
            (otherUserData.type == "Ghost" and otherUserData.physicsEntity.box:getType() == "dynamic")
        ) then
        self.contacts[other] = nil
        local count = 0
        for _, _ in pairs(self.contacts) do
            count = count + 1
        end

        if count <= 0 then
            self.sprite = self.spriteDeactivated
            self.activated = false
        end
    end
end

function Sensor:update(dt, ghosts)
    local GhostManager = require("src.ghostManager")
    local ghosts = GhostManager.ghosts
    local sx, sy = self.body:getPosition()
    local tileSize = 32

    local activated = false
    for _, ghost in ipairs(ghosts) do
        if ghost.physicsEntity and not ghost.physicsEntity.dead then
            local gx, gy = ghost.physicsEntity.box:getPosition()
            if math.abs(gx - sx) <= tileSize and math.abs(gy - sy) <= tileSize then
                activated = true
                break
            end
        end
    end

    local count = 0
    for _, _ in pairs(self.contacts) do
        count = count + 1
    end

    if activated then
        self.activated = true
        self.sprite = self.spriteActivated
    elseif not activated and count <= 0 then
        self.activated = false
        self.sprite = self.spriteDeactivated
    end
end

function Sensor:draw()
    love.graphics.setColor(1, 1, 1, 1)
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    love.graphics.draw(self.sprite, x, y, angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

return Sensor
