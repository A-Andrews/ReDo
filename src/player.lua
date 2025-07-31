local GhostManager = require("src.ghostManager")
local PlayerAttributes = require("src.playerAttributes")

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

end

function Player:reset()
    self.x = self.start_x
    self.y = self.start_y
    self.y_velocity = 0
    self.isRecording = true
    GhostManager:addGhost(self.recordedActions)
    self.recordedActions = {}
    self.recordStartTime = love.timer.getTime()
end

function Player:keypressed(key)
    if key == "r" then
        self:reset()
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
    if love.keyboard.isDown('d') and self.x < (love.graphics.getWidth() - self.img:getWidth()) then
        self.x = self.x + (self.speed * dt)
    elseif love.keyboard.isDown('a') and self.x > 0 then
        self.x = self.x - (self.speed * dt)
    end

    if love.keyboard.isDown('space') and self.y_velocity == 0 then
        self.y_velocity = self.jump_height
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
end

return Player
