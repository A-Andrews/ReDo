local Countdown = {}

function Countdown:load()
    self.time = 10 -- Countdown starts at 10 seconds
    self.running = true
end

function Countdown:keypressed(key)
    if key == "r" then
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
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("".. math.ceil(self.time), 10, 10, nil, 2, 2)
    end
end

function Countdown:reset()
    self.time = 10
    self.running = true
end

return Countdown
