local Player = {}

function Player:load()
    self.start_x = love.graphics.getWidth() / 2
    self.start_y = love.graphics.getHeight() / 2
    self.x = self.start_x
    self.y = self.start_y

    self.img = love.graphics.newImage("images/player.png")
    self.speed = 200

    self.ground = self.y

    self.y_velocity = 0
    self.jump_height = -300
    self.gravity = -500

    self.isRecording = true
    self.recordStartTime = love.timer.getTime()
    self.recordDuration = 10
    self.recordedActions = {}
end

function Player:reset()
    for i, pos in ipairs(Player.recordedActions) do
        print(string.format("t=%.2f x=%.2f y=%.2f", pos.t, pos.x, pos.y))
    end
    self.x = self.start_x
    self.y = self.start_y
    self.y_velocity = 0
    self.isRecording = true
    self.recordedActions = {}
    self.recordStartTime = love.timer.getTime()
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

    if love.keyboard.isDown('r') then
        self:reset()
    end
    self:record()
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
end

return Player
