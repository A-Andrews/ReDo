local GhostManager = {}

function GhostManager:load()
    self.ghosts = {}
end

function GhostManager:addGhost(ghost)
    table.insert(self.ghosts, ghost)
end

function GhostManager:update(dt)
    for _, ghost in ipairs(self.ghosts) do
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
