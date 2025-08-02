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
    ghost.alpha = 0.5
    ghost.startTime = love.timer.getTime()
    ghost.currentActionIndex = 1
    ghost.timeElapsed = 0
    ghost.duration = Countdown.duration
    ghost.type = "Ghost"
    ghost.colour = PlayerAttributes.colour

    ghost.physicsEntity = PhysicsEntity:new()
    ghost.physicsEntity.boxFixture:setUserData(ghost)
    ghost.canCollideWithPlayer = false
    WorldManager:registerCollisionCallback(ghost.physicsEntity.boxFixture,
        { owner = ghost, beginContact = ghost.beginContact, endContact = ghost.endContact, preSolve = ghost.preSolve })

    ghost.id = love.timer.getTime()
    ghost.collidableGhosts = {}

    return ghost
end

function Ghost:preSolve(other, coll)
    local userdata = other:getUserData()
    if userdata then
        if userdata.type == "Ghost" and self.collidableGhosts[userdata.id] == nil then
            coll:setEnabled(false)
        end
        if userdata.type == "Player" and not self.canCollideWithPlayer then
            coll:setEnabled(false)
        end
    end
end

function Ghost:beginContact(other, coll)
    local userdata = other:getUserData()
    if userdata then
        if userdata.type == "Platform" then
            self.physicsEntity.onGround = true
        end
    end
end

function Ghost:endContact(other, coll)
    local userdata = other:getUserData()
    if userdata then
        if userdata.type == "Platform" then
            self.physicsEntity.onGround = false
        end
        if userdata.type == "Ghost" and self.collidableGhosts[userdata.id] == nil then
            self.collidableGhosts[userdata.id] = true
        end
        if userdata.type == "Player" then
            self.canCollideWithPlayer = true
        end
    end
end

function Ghost:reset()
    self.physicsEntity:reset()
    self.currentActionIndex = 1
    self.timeElapsed = 0
    self.startTime = love.timer.getTime()
    self.collidableGhosts = {}
    self.canCollideWithPlayer = false
end

function Ghost:update(dt)
    if self.currentActionIndex <= #self.recordedActions then
        local action = self.recordedActions[self.currentActionIndex]
        self.timeElapsed = action.t

        if love.timer.getTime() - self.startTime >= self.timeElapsed then
            MovementController.updateMovement(self, action)
        end
        self.currentActionIndex = self.currentActionIndex + 1
    elseif self.timeElapsed >= self.duration then
        self:reset()
    else
        self.timeElapsed = self.timeElapsed + dt
    end
end

function Ghost:draw()
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.alpha)
    love.graphics.polygon("fill", self.physicsEntity.box:getWorldPoints(self.physicsEntity.boxShape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Ghost
