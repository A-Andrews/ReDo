local PlayerAttributes = require("src.playerAttributes")
local WorldAttributes = require("src.worldAttributes")
local MovementController = {}

function MovementController.updateMovement(entity, input)
    local box = entity.physicsEntity.box
    local vx, vy = box:getLinearVelocity()

    if input.right and box:getX() < (love.graphics.getWidth() - PlayerAttributes.size / 2) then
        vx = entity.physicsEntity.speed
    elseif input.left and box:getX() - PlayerAttributes.size / 2 > 0 then
        vx = -entity.physicsEntity.speed
    else
        vx = 0
    end
    box:setLinearVelocity(vx, vy)

    MovementController.jump(entity, input.jump)
end

function MovementController.jump(entity, jump)
    local box = entity.physicsEntity.box
    local _, vy = box:getLinearVelocity()

    if vy < 0 then
        if jump then
            box:applyForce(0, WorldAttributes.gravity * 0.1)
        else
            box:applyForce(0, WorldAttributes.gravity)
        end
    end

    local count = 0
    for _, _ in pairs(entity.physicsEntity.contacts) do
        count = count + 1
    end

    -- Checks whether it is possible to jump based on whether the player is on the ground or has coyote time left
    local canJump = count > 0 or
        (love.timer.getTime() - entity.physicsEntity.leftGroundTime < entity.physicsEntity.coyoteTime)

    -- Allows jumping just before hitting the ground
    local bufferedJump = love.timer.getTime() - entity.physicsEntity.jumpBufferTime < entity.physicsEntity.jumpBuffer
    
    if jump and not entity.physicsEntity.jumpPressed then
        entity.physicsEntity.jumpBufferTime = love.timer.getTime()
        entity.physicsEntity.jumpPressed = true
        entity.physicsEntity.hasJumped = false
    elseif not jump then
        entity.physicsEntity.jumpPressed = false
    end

    if jump and canJump and bufferedJump and not entity.physicsEntity.hasJumped then
        box:applyLinearImpulse(0, entity.physicsEntity.jumpHeight)
        entity.physicsEntity.hasJumped = true
    end
end

return MovementController
