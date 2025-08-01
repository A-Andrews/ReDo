local ScoreManager = {}

function ScoreManager:load()
    self.score = 0
    self.x = love.graphics.getWidth() - 110
    self.y = 10
    self.scale = 2
    self.colour = {r = 1, g = 1, b = 1}
end

function ScoreManager:addScore(points)
    -- we want this to be called by the level and have it add a set number of points minus the number of ghosts used
    self.score = self.score + points
end

function ScoreManager:reset()
    self.score = 0
end

function ScoreManager:getScore()
    return self.score
end

function ScoreManager:draw()
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
    love.graphics.print("Score: " .. self.score, self.x, self.y, nil, self.scale, self.scale)
end

return ScoreManager
