local GhostManager = require("src.ghostManager")
local PlayerAttributes = require("src.playerAttributes")
local WorldManager = require("src.worldManager")
local MovementController = require("src.movementController")
local PhysicsEntity = require("src.physicsEntity")

local Player = {}

function Player:load()
    -- self.start_x = PlayerAttributes.start_x
    -- self.start_y = PlayerAttributes.start_y - PlayerAttributes.size / 2

    -- self.speed = PlayerAttributes.speed

    -- self.jump_height = PlayerAttributes.jump_height

    self.isRecording = true
    self.recordStartTime = love.timer.getTime()
    self.recordDuration = 10
    self.recordedActions = {}
    self.type = "Player"

    self.physicsEntity = PhysicsEntity:new()

    -- self.box = love.physics.newBody(WorldManager:getWorld(), self.start_x, self.start_y, "dynamic")
    -- self.boxShape = love.physics.newRectangleShape(PlayerAttributes.size, PlayerAttributes.size)
    -- self.boxFixture = love.physics.newFixture(self.box, self.boxShape)
    
    self.physicsEntity.boxFixture:setUserData(self)
    -- self.box:setLinearDamping(4)

    self.onGround = false

    WorldManager:registerCollisionCallback(self.physicsEntity.boxFixture, { owner = self, beginContact = self.beginContact, endContact = self.endContact})
end

function Player:beginContact(other, coll)
    if other:getUserData() and other:getUserData().type == "Platform" then
        self.physicsEntity.onGround = true
    end
end

function Player:endContact(other, coll)
    if other:getUserData() and other:getUserData().type == "Platform" then
        self.physicsEntity.onGround = false
    end
end

function Player:reset(addGhost)
    self.physicsEntity.box:setPosition(self.physicsEntity.start_x, self.physicsEntity.start_y)
    self.physicsEntity.box:setLinearVelocity(0, 0)
    self.isRecording = true
    if addGhost then
        GhostManager:addGhost(self.recordedActions)
    end
    self.recordedActions = {}
    self.recordStartTime = love.timer.getTime()
end

function Player:keypressed(key)
    if key == "r" then
        self:reset(true)
    end
end

function Player:record()
    if self.isRecording then
        local currentTime = love.timer.getTime()
        table.insert(self.recordedActions, { left = love.keyboard.isDown('d'), right = love.keyboard.isDown('a'), jump = love.keyboard.isDown('space'), t = currentTime - self.recordStartTime })
    
        if currentTime - self.recordStartTime > self.recordDuration then
            self.isRecording = false
            self:reset()
        end
    end
end

function Player:update(dt)

    MovementController.updateMovement(self, { left = love.keyboard.isDown('a'), right = love.keyboard.isDown('d'), jump = love.keyboard.isDown('space') })
    self:record()
end

function Player:draw()
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", self.physicsEntity.box:getWorldPoints(self.physicsEntity.boxShape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Player
