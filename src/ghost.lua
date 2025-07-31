local Ghost = {}
Ghost.__index = Ghost

function Ghost:new(recordedActions)
    local ghost = setmetatable({}, Ghost)
    ghost.recordedActions = recordedActions
    self.start_x = love.graphics.getWidth() / 2
    self.start_y = love.graphics.getHeight() / 2
    self.img = love.graphics.newImage("images/player.png")
    return ghost
end

function Ghost:update(dt)
    --placeholder for ghost update logic
end

function Ghost:draw()
    print("Drawing ghost with actions: " .. #self.recordedActions)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
end

return Ghost
