local playerAttributes = {
    startX = love.graphics.getWidth() / 2,
    startY = love.graphics.getHeight() / 2,
    img = love.graphics.newImage("images/player.png"),
    speed = 500,
    jumpHeight = -150,
    linearDamping = 0.5,
    size = 28,
    colour = { r = 0.28, g = 0.63, b = 0.05 },
    coyoteTime = 0.1,
    jumpBuffer = 0.1,
}

return playerAttributes
