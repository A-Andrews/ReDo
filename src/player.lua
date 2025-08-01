local GhostManager = require("src.ghostManager")
local PlayerAttributes = require("src.playerAttributes")
local WorldManager = require("src.worldManager")

local Player = {}

function Player:load()
    self.start_x = PlayerAttributes.start_x
    self.start_y = PlayerAttributes.start_y
    self.x = self.start_x
    self.y = self.start_y

    self.img = PlayerAttributes.img
    self.speed = PlayerAttributes.speed

    self.ground = self.y

    self.y_velocity = 0
    self.jump_height = PlayerAttributes.jump_height
    self.gravity = PlayerAttributes.gravity

    self.isRecording = true
    self.recordStartTime = love.timer.getTime()
    self.recordDuration = 10
    self.recordedActions = {}

    self.box = love.physics.newBody(WorldManager:getWorld(), self.start_x, self.start_y, "dynamic")
    self.boxShape = love.physics.newRectangleShape(32, 32)
    self.boxFixture = love.physics.newFixture(self.box, self.boxShape)
    self.boxFixture:setUserData("Player")
    self.box:setLinearDamping(4)

    self.onGround = false

end

function Player:reset(addGhost)
    self.x = self.start_x
    self.y = self.start_y
    self.y_velocity = 0
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
        table.insert(self.recordedActions, { x = self.x, y = self.y, t = currentTime - self.recordStartTime })
    
        if currentTime - self.recordStartTime > self.recordDuration then
            self.isRecording = false
            self:reset()
        end
    end
end

function Player:update(dt)
    local vx, vy = self.box:getLinearVelocity()

    if love.keyboard.isDown('d') and self.x < (love.graphics.getWidth() - self.img:getWidth()) then
        self.x = self.x + (self.speed * dt)
        vx = self.speed
    elseif love.keyboard.isDown('a') and self.x > 0 then
        self.x = self.x - (self.speed * dt)
        vx = -self.speed
    end

    self.box:setLinearVelocity(vx, vy)

    if love.keyboard.isDown('space') and self.onGround then
        -- fix double jumping and inifnite jumping when pressed once issue
        self.y_velocity = self.jump_height
        self.box:applyLinearImpulse(vx, self.jump_height)
    end

    if self.y_velocity ~= 0 then
        self.y = self.y + self.y_velocity * dt
        self.y_velocity = self.y_velocity - self.gravity * dt
    end

    if self.y > self.ground then
        self.y_velocity = 0
        self.y = self.ground
    end
    self:record()
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", self.box:getWorldPoints(self.boxShape:getPoints()))
    love.graphics.setColor(1, 1, 1)
end

return Player
