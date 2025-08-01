local PlayerAttributes = require("src.playerAttributes")
local WorldManager = require("src.worldManager")
local CollisionCategories = require("src.collisionCategories")
local Ghost = {}
Ghost.__index = Ghost

function Ghost:new(recordedActions)
    local ghost = setmetatable({}, Ghost)
    ghost.recordedActions = recordedActions
    ghost.start_x = PlayerAttributes.start_x
    ghost.start_y = PlayerAttributes.start_y

    ghost.img = PlayerAttributes.img
    ghost.speed = PlayerAttributes.speed
    ghost.jump_height = PlayerAttributes.jump_height
    ghost.gravity = PlayerAttributes.gravity

    ghost.x = ghost.start_x
    ghost.y = ghost.start_y

    ghost.alpha = 0.5

    ghost.startTime = love.timer.getTime()
    ghost.currentActionIndex = 1
    ghost.timeElapsed = 0

    ghost.box = love.physics.newBody(WorldManager:getWorld(), ghost.start_x, ghost.start_y, "dynamic")
    ghost.boxShape = love.physics.newRectangleShape(32, 32)
    ghost.boxFixture = love.physics.newFixture(ghost.box, ghost.boxShape)
    ghost.type = "Ghost"
    ghost.boxFixture:setUserData(ghost)
    ghost.box:setLinearDamping(4)

    ghost.boxFixture:setCategory(CollisionCategories.GHOST)
    ghost.boxFixture:setMask(CollisionCategories.PLAYER, CollisionCategories.GHOST)

    ghost.onGround = false

    WorldManager:registerCollisionCallback(ghost.boxFixture,
        { owner = ghost, beginContact = ghost.beginContact, endContact = ghost.endContact })
    return ghost
end

function Ghost:beginContact(other, coll)
    if other:getUserData() and other:getUserData().type == "Platform" then
        self.onGround = true
    end
end

function Ghost:endContact(other, coll)
    if other:getUserData() and other:getUserData().type == "Platform" then
        self.onGround = false
    end
end

function Ghost:reset()
    self.box:setPosition(self.start_x, self.start_y)
    self.box:setLinearVelocity(0, 0)
    self.currentActionIndex = 1
    self.timeElapsed = 0
    self.startTime = love.timer.getTime()
end

function Ghost:update(dt)
    if self.currentActionIndex <= #self.recordedActions then
        local action = self.recordedActions[self.currentActionIndex]
        self.timeElapsed = action.t

        if love.timer.getTime() - self.startTime >= self.timeElapsed then
            local vx, vy = self.box:getLinearVelocity()

            if action.left and self.x < (love.graphics.getWidth() - self.img:getWidth()) then
                vx = self.speed
            elseif action.right and self.x > 0 then
                vx = -self.speed
            end

            self.box:setLinearVelocity(vx, vy)

            if action.jump and self.onGround then
                self.box:applyLinearImpulse(0, self.jump_height)
            end
        end
        self.currentActionIndex = self.currentActionIndex + 1
    else
        self:reset()
    end
end

function Ghost:draw()
    love.graphics.setColor(0.28, 0.63, 0.05, self.alpha)
    love.graphics.polygon("fill", self.box:getWorldPoints(self.boxShape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Ghost
