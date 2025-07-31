local Platform = require("src.platform")
local Player = require("src.player")

function love.load()
    Platform:load()
    Player:load()
end

function love.update(dt)
    Platform:update(dt)
    Player:update(dt)
end

function love.draw()
    Platform:draw()
    Player:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    Player:keypressed(key)
end
