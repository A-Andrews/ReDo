local LevelManager = require("src.levelManager")
local Countdown = {}

function Countdown:load()
    self.duration = LevelManager.timeLimit
    self.time = self.duration
    self.running = true
    self.x = 10
    self.y = 10
    self.scale = 1
    self.colour = { r = 1, g = 0, b = 0 }
    self.font = love.graphics.newFont(20)
end

function Countdown:keypressed(key)
    if key == "r" or key == "c" or key == "f" then
        self:reset()
    end
end

function Countdown:update(dt)
    if self.running then
        self.time = self.time - dt
        if self.time <= 0 then
            Countdown:reset()
        end
    end
end

function Countdown:draw()
    if self.running then
        love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
        love.graphics.print("" .. math.ceil(self.time), self.font, self.x, self.y, nil, self.scale, self.scale)
    end
end

function Countdown:reset()
    self.time = self.duration
    self.running = true
end

return Countdown
