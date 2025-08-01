local PlayerAttributes = require("src.playerAttributes")
local WorldManager = require("src.worldManager")
local Ghost = {}
Ghost.__index = Ghost

function Ghost:new(recordedActions)
    local ghost = setmetatable({}, Ghost)
    ghost.recordedActions = recordedActions
    self.start_x = PlayerAttributes.start_x
    self.start_y = PlayerAttributes.start_y

    self.img = PlayerAttributes.img
    self.speed = PlayerAttributes.speed
    self.jump_height = PlayerAttributes.jump_height
    self.gravity = PlayerAttributes.gravity

    self.x = self.start_x
    self.y = self.start_y
    self.img = love.graphics.newImage("images/player.png")
    self.alpha = 0.5

    self.startTime = love.timer.getTime()
    self.currentActionIndex = 1
    self.timeElapsed = 0

    self.box = love.physics.newBody(WorldManager:getWorld(), self.start_x, self.start_y, "dynamic")
    self.boxShape = love.physics.newRectangleShape(32, 32)
    self.boxFixture = love.physics.newFixture(self.box, self.boxShape)
    self.type = "Ghost"
    self.boxFixture:setUserData(self)
    self.box:setLinearDamping(4)

    self.onGround = false

    WorldManager:registerCollisionCallback(self.boxFixture,
        { owner = self, beginContact = self.beginContact, endContact = self.endContact })
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
