local WorldManager = require("src.worldManager")
local PlayerAttributes = require("src.playerAttributes")
local PhysicsEntity = {}
PhysicsEntity.__index = PhysicsEntity

function PhysicsEntity:new()
    local physicsEntity = setmetatable({}, PhysicsEntity)
    physicsEntity.start_x = PlayerAttributes.start_x
    physicsEntity.start_y = PlayerAttributes.start_y - PlayerAttributes.size / 2
    physicsEntity.speed = PlayerAttributes.speed
    physicsEntity.jump_height = PlayerAttributes.jump_height

    physicsEntity.box = love.physics.newBody(WorldManager:getWorld(), physicsEntity.start_x, physicsEntity.start_y, "dynamic")
    physicsEntity.boxShape = love.physics.newRectangleShape(PlayerAttributes.size, PlayerAttributes.size)
    physicsEntity.boxFixture = love.physics.newFixture(physicsEntity.box, physicsEntity.boxShape)
    physicsEntity.box:setLinearDamping(4)
    return physicsEntity
end

return PhysicsEntity
