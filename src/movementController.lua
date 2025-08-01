local PlayerAttributes = require("src.playerAttributes")
local MovementController = {}

function MovementController.updateMovement(entity, input)
    local box = entity.physicsEntity.box
    local vx, vy = box:getLinearVelocity()

    if input.right and box:getX() < (love.graphics.getWidth() - PlayerAttributes.size / 2) then
        vx = entity.physicsEntity.speed
    end
    if input.left and box:getX() > 0 then
        vx = -entity.physicsEntity.speed
    end
    box:setLinearVelocity(vx, vy)
    if input.jump and entity.physicsEntity.onGround then
        box:applyLinearImpulse(0, entity.physicsEntity.jump_height)
    end
end

return MovementController
