local Platform = require("src.platform")
function love.load()
    Platform:load()
end

function love.update(dt)
    Platform:update(dt)
end

function love.draw()
    Platform:draw()
end
