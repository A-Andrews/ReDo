local playerAttributes = {
    start_x = love.graphics.getWidth() / 2,
    start_y = love.graphics.getHeight() / 2,
    img = love.graphics.newImage("images/player.png"),
    speed = 500,
    jump_height = -200,
    gravity = -500,
    linearDamping = 4,
    size = 32,
    colour = { r = 0.28, g = 0.63, b = 0.05 }
}

return playerAttributes
