local WorldManager = {}

function WorldManager:load()
    local gravity = 35
    love.physics.setMeter(64)
    self.world = love.physics.newWorld(0, gravity * 64, true)
    self.world:setCallbacks(self.beginContact, self.endContact)
end

function WorldManager:getWorld()
    return self.world
end

function WorldManager:update(dt)
    self.world:update(dt)
end

return WorldManager
