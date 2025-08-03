local MovingPlatformManager = {}

MovingPlatformManager.movingPlatforms = {}

function MovingPlatformManager:load()
    self.movingPlatforms = {}
end

function MovingPlatformManager:addMovingPlatform(platform)
    table.insert(self.movingPlatforms, platform)
end

function MovingPlatformManager:update(dt)
    for _, platform in ipairs(self.movingPlatforms) do
        platform:update(dt)
    end
end

function MovingPlatformManager:reset()
    self.movingPlatforms = {}
end

return MovingPlatformManager
