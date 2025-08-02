local GhostManager = require("src.ghostManager")
local WorldManager = require("src.worldManager")
local MovementController = require("src.movementController")
local PhysicsEntity = require("src.physicsEntity")
local PlayerAttributes = require("src.playerAttributes")
local Countdown = require("src.countdown")


local Player = {}

function Player:load()

    self.isRecording = true
    self.recordStartTime = love.timer.getTime()
    self.recordDuration = Countdown.duration
    self.recordedActions = {}
    self.type = "Player"
    self.colour = PlayerAttributes.colour

    self.physicsEntity = PhysicsEntity:new()
    self.physicsEntity.boxFixture:setUserData(self)
    WorldManager:registerCollisionCallback(self.physicsEntity.boxFixture, { owner = self, beginContact = self.beginContact, endContact = self.endContact})
end

function Player:beginContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Platform" or (otherUserData.type == "Ghost"and otherUserData.canCollideWithPlayer)) then
        print("Player began contact with " .. otherUserData.type)
        self.physicsEntity.onGround = true
        self.physicsEntity.leftGroundTime = 0
        self.physicsEntity.groundContacts = self.physicsEntity.groundContacts + 1
        print("Ground contacts: " .. self.physicsEntity.groundContacts)
    end
end

function Player:endContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData and (otherUserData.type == "Platform" or (otherUserData.type == "Ghost" and otherUserData.canCollideWithPlayer)) then
        self.physicsEntity.groundContacts = math.max(0, self.physicsEntity.groundContacts - 1)
        print("Ground contacts: " .. self.physicsEntity.groundContacts)
        if self.physicsEntity.groundContacts == 0 then
            self.physicsEntity.onGround = false
            self.physicsEntity.leftGroundTime = love.timer.getTime()
        end
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
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
    love.graphics.polygon("fill", self.physicsEntity.box:getWorldPoints(self.physicsEntity.boxShape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Player
