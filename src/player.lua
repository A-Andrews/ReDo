local Player = {}

function Player:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2

    self.img = love.graphics.newImage("images/player.png")
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
end

return Player
