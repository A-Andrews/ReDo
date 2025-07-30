local Player = {}

function Player:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2

    self.img = love.graphics.newImage("images/player.png")
    self.speed = 200

    self.ground = self.y

    self.y_velocity = 0
    self.jump_height = -300
    self.gravity = -500
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

end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
end

return Player
