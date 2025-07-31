local Ghost = require("src.ghost")
local GhostManager = {}

function GhostManager:load()
    self.ghosts = {}
end

function GhostManager:keypressed(key)
    if key == "r" then
        for i, ghost in ipairs(self.ghosts) do
            ghost:reset()
        end
    end
end

function GhostManager:addGhost(actions)
    print("Adding ghost with actions: " .. #actions)
    local ghost = Ghost:new(actions)
    table.insert(self.ghosts, ghost)
end

function GhostManager:update(dt)
    for i, ghost in ipairs(self.ghosts) do
        ghost:update(dt)
    end
end

function GhostManager:draw()
    for _, ghost in ipairs(self.ghosts) do
        ghost:draw()
    end
end

function GhostManager:reset()
    self.ghosts = {}
end

return GhostManager
