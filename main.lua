local Platform = require("src.platform")
local Player = require("src.player")

function love.load()
    Platform:load()
    Player:load()
end

function love.update(dt)
    Platform:update(dt)
end

function love.draw()
    Platform:draw()
    Player:draw()
end
