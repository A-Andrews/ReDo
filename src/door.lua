local WorldManager = require("src.worldManager")
local PhysicsEntity = require("src.physicsEntity")
local SensorManager = require("src.sensorManager")
local Door = {}
Door.__index = Door


function Door:new(tileSize, tileX, tileY)
    local door = setmetatable({}, Door)
    door.x = (tileSize * (tileX - 1)) + (tileSize / 2)
    door.y = (tileSize * (tileY - 1)) + (tileSize / 2)
    door.isOpen = false -- Door always starts closed

    -- door.spriteClosed = love.graphics.newImage("images/door_open.png")
    -- door.spriteOpen = love.graphics.newImage("images/door_closed.png")
    -- door.sprite = door.spriteClosed

    door.body = love.physics.newBody(WorldManager:getWorld(), door.x, door.y, "static")
    door.shape = love.physics.newRectangleShape(tileSize, tileSize)
    door.fixture = love.physics.newFixture(door.body, door.shape)
    door.fixture:setUserData(door)
    door.type = "Door"
    WorldManager:registerCollisionCallback(door.fixture,
        { owner = door, beginContact = door.beginContact, endContact = door.endContact, preSolve = door.preSolve })
    return door
end

function Door:preSolve(other, coll)
    if self.isOpen then
        coll:setEnabled(false)
    else
        coll:setEnabled(true)
    end
end

function Door:draw()
    local x, y = self.body:getPosition()
    if self.isOpen then
        self.fixture =
            love.graphics.setColor(0, 200, 0, 1)
    else
        love.graphics.setColor(200, 0, 0, 1)
    end
    love.graphics.circle("fill", x, y, 20)
end

return Door
