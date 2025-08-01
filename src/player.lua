local GhostManager = require("src.ghostManager")
local WorldManager = require("src.worldManager")
local MovementController = require("src.movementController")
local PhysicsEntity = require("src.physicsEntity")

local Player = {}

function Player:load()

    self.isRecording = true
    self.recordStartTime = love.timer.getTime()
    self.recordDuration = 10
    self.recordedActions = {}
    self.type = "Player"

    self.physicsEntity = PhysicsEntity:new()
    
    self.physicsEntity.boxFixture:setUserData(self)

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
    self.physicsEntity:reset()
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
        table.insert(self.recordedActions, { left = love.keyboard.isDown('a'), right = love.keyboard.isDown('d'), jump = love.keyboard.isDown('space'), t = currentTime - self.recordStartTime })
    
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
