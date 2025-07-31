local PlayerAttributes = require("src.playerAttributes")
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
    self. alpha = 0.5
    return ghost
end

function Ghost:update(dt)
    if #self.recordedActions > 0 then
        for i, action in ipairs(self.recordedActions) do
            self.x = action.x
            self.y = action.y
        end
    else
        self.alpha = 0 -- reset ghost if no actions left
    end
end

function Ghost:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 32)
    love.graphics.setColor(1, 1, 1, 1)
end

return Ghost
