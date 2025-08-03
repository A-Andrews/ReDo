local WorldManager = require("src.worldManager")
local MovementController = require("src.movementController")
local PhysicsEntity = require("src.physicsEntity")
local PlayerAttributes = require("src.playerAttributes")
local Countdown = require("src.countdown")
local Ghost = {}
Ghost.__index = Ghost

function Ghost:new(recordedActions)
    local ghost = setmetatable({}, Ghost)

    ghost.recordedActions = recordedActions
    ghost.alpha = 0.7
    ghost.startTime = love.timer.getTime()
    ghost.currentActionIndex = 1
    ghost.timeElapsed = 0
    ghost.duration = Countdown.duration
    ghost.type = "Ghost"
    self.spriteLeft = love.graphics.newImage("images/player_left.png")
    self.spriteRight = love.graphics.newImage("images/player_right.png")
    self.spriteSpin = love.graphics.newImage("images/player_spin.png")
    self.spriteJumpLeft = love.graphics.newImage("images/player_jump_left.png")
    self.spriteJumpRight = love.graphics.newImage("images/player_jump_right.png")
    self.sprite = self.spriteLeft
    self.fadeInValue = 0.4
    self.colour = { r = 173 / 255, g = 216 / 255, b = 230 / 255 }

    ghost.physicsEntity = PhysicsEntity:new()
    ghost.physicsEntity.boxFixture:setUserData(ghost)
    ghost.canCollideWithPlayer = false
    WorldManager:registerCollisionCallback(ghost.physicsEntity.boxFixture,
        { owner = ghost, beginContact = ghost.beginContact, endContact = ghost.endContact, preSolve = ghost.preSolve })

    ghost.id = love.timer.getTime()
    ghost.collidableGhosts = {}
    ghost.ignoreTime = 2
    ghost.spawnedAt = love.timer.getTime()

    ghost.physicsEntity.dead = false

    return ghost
end

function Ghost:preSolve(other, coll)
    local now = love.timer.getTime()

    local userdata = other:getUserData()
    if userdata then
        if userdata.type == "Ghost" and (self.collidableGhosts[userdata.id] == nil or now - self.spawnedAt < self.ignoreTime) then
            coll:setEnabled(false)
        end
        if userdata.type == "Player" and (not self.canCollideWithPlayer or now - self.spawnedAt < self.ignoreTime) then
            coll:setEnabled(false)
        end
    end
end

function Ghost:beginContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData then
        if otherUserData.type == "Platform" or otherUserData.type == "MovingPlatform" or otherUserData.type == "Ghost" or otherUserData.type == "Player" then
            self.physicsEntity.contacts[other] = true
            self.physicsEntity.leftGroundTime = 0
        elseif otherUserData.type == "Spikes" then
            self.physicsEntity.dead = true
        end
    end
end

function Ghost:endContact(other, coll)
    local otherUserData = other:getUserData()
    if otherUserData then
        if otherUserData.type == "Ghost" and self.collidableGhosts[otherUserData.id] == nil then
            self.collidableGhosts[otherUserData.id] = true
        end
        if otherUserData.type == "Player" then
            self.canCollideWithPlayer = true
        end
        if self.physicsEntity.contacts[other] == true then
            self.physicsEntity.contacts[other] = nil
            self.physicsEntity.leftGroundTime = love.timer.getTime()
        end
    end
end

function Ghost:reset()
    self.physicsEntity.box:setType("dynamic")
    self.physicsEntity:reset()
    self.currentActionIndex = 1
    self.timeElapsed = 0
    self.startTime = love.timer.getTime()
    self.collidableGhosts = {}
    self.canCollideWithPlayer = false
    self.physicsEntity.box:setActive(true)
    self.spawnedAt = love.timer.getTime()
end

function Ghost:update(dt)
    if self.physicsEntity.dead then
        self.physicsEntity.box:setActive(false)
    end
    self.timeElapsed = self.timeElapsed + dt
    while self.currentActionIndex <= #self.recordedActions and
        self.recordedActions[self.currentActionIndex].t <= self.timeElapsed do
        MovementController.updateMovement(self, self.recordedActions[self.currentActionIndex])
        self.currentActionIndex = self.currentActionIndex + 1
    end

    if self.timeElapsed >= self.duration then
        self:reset()
    elseif self.currentActionIndex > #self.recordedActions then
        self.physicsEntity.box:setLinearVelocity(0, 0)
        self.physicsEntity.box:setType("static")
    end
end

function Ghost:draw()
    if self.physicsEntity.dead then
        return
    end

    local alpha = self.alpha

    local timeSinceSpawn = love.timer.getTime() - self.spawnedAt
    if timeSinceSpawn < self.ignoreTime then
        alpha = 0.1 + self.fadeInValue * (timeSinceSpawn / self.ignoreTime) -- fade in
    end
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, alpha)

    local x, y = self.physicsEntity.box:getPosition()
    local angle = self.physicsEntity.box:getAngle()
    local vx, vy = self.physicsEntity.box:getLinearVelocity()

    if vx <= 0 then
        self.sprite = self.spriteLeft
        if vy < 0 then
            self.sprite = self.spriteJumpLeft
        end
    else
        self.sprite = self.spriteRight
        if vy < 0 then
            self.sprite = self.spriteJumpRight
        end
    end

    if math.abs(self.physicsEntity.box:getAngularVelocity()) > 4 then
        self.sprite = self.spriteSpin
    end

    love.graphics.draw(self.sprite, x, y, angle, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
end

function Ghost:destroy()
    self.physicsEntity.box:destroy()
end

return Ghost
