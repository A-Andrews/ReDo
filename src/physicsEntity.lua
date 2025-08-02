local WorldManager = require("src.worldManager")
local PlayerAttributes = require("src.playerAttributes")
local PhysicsEntity = {}
PhysicsEntity.__index = PhysicsEntity

function PhysicsEntity:new()
    local physicsEntity = setmetatable({}, PhysicsEntity)
    physicsEntity.startX = PlayerAttributes.startX
    physicsEntity.startY = PlayerAttributes.startY - PlayerAttributes.size / 2
    physicsEntity.speed = PlayerAttributes.speed
    physicsEntity.dead = false

    physicsEntity.jumpHeight = PlayerAttributes.jumpHeight
    physicsEntity.coyoteTime = PlayerAttributes.coyoteTime
    physicsEntity.leftGroundTime = 0
    physicsEntity.jumpBuffer = PlayerAttributes.jumpBuffer
    physicsEntity.jumpBufferTime = 0
    physicsEntity.hasJumped = false
    physicsEntity.jumpPressed = false
    physicsEntity.contacts = {}

    physicsEntity.box = love.physics.newBody(WorldManager:getWorld(), physicsEntity.startX, physicsEntity.startY, "dynamic")
    physicsEntity.boxShape = love.physics.newRectangleShape(PlayerAttributes.size, PlayerAttributes.size)
    physicsEntity.boxFixture = love.physics.newFixture(physicsEntity.box, physicsEntity.boxShape)
    physicsEntity.box:setLinearDamping(PlayerAttributes.linearDamping)
    return physicsEntity
end

function PhysicsEntity:reset()
    self.box:setPosition(self.startX, self.startY)
    self.box:setLinearVelocity(0, 0)
    self.leftGroundTime = 0
    self.jumpBufferTime = 0
    self.hasJumped = false
    self.jumpPressed = false
    self.contacts = {}
    self.dead = false
end

return PhysicsEntity
