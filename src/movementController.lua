local MovementController = {}
-- this is to handle movement from the player and from ghosts

function MovementController.updateMovement(entity, input)
    local box = entity.box
    local vx, vy = box:getLinearVelocity()

    if input.right and entity.box:getX() < (love.graphics.getWidth() - entity.img:getWidth()) then
        vx = entity.speed
    end
    if input.left and entity.box:getX() > 0 then
        vx = -entity.speed
    end
    box:setLinearVelocity(vx, vy)
    if input.jump and entity.onGround then
        box:applyLinearImpulse(0, entity.jump_height)
    end
end

return MovementController
