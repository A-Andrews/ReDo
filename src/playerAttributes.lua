local playerAttributes = {
    start_x = love.graphics.getWidth() / 2,
    start_y = love.graphics.getHeight() / 2,
    img = love.graphics.newImage("images/player.png"),
    speed = 500,
    jump_height = -200,
    gravity = -500,
}

return playerAttributes
