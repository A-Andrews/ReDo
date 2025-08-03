local WorldManager = require("src.worldManager")
local Platform = require("src.platform")
local LevelManager = require("src.levelManager")
local Player = require("src.player")
local GhostManager = require("src.ghostManager")
local Countdown = require("src.countdown")
local ScoreManager = require("src.scoreManager")
local MovingPlatformManager = require("src.movingPlatformManager")
local SensorManager = require("src.sensorManager")

local LevelNumber = 1 -- level number (starts at 1 and increments)

Reset = function()
    Countdown:load()
    Player:load()
    GhostManager:load()
end

function love.load()
    GhostManager:load()
    WorldManager:load()
    ScoreManager:load()
    LevelManager:loadLevel(LevelNumber)
    Reset()
end

function love.update(dt)
    WorldManager:update(dt)
    LevelManager:update(dt)
    Countdown:update(dt)
    Player:update(dt)
    GhostManager:update(dt)

    SensorManager:update(dt, GhostManager.ghosts)
    MovingPlatformManager:update(dt, Countdown.time)

    -- Placeholder logic for moving between levels
    for i, point in ipairs(LevelManager.finishPoints) do
        if ((Player.physicsEntity.box:getX() - point.finishX) ^ 2 + (Player.physicsEntity.box:getY() - point.finishY) ^ 2) < 1000 then
            ScoreManager:addScore((LevelNumber * 10) + LevelManager.timeLimit - Countdown.time - #GhostManager.ghosts)
            LevelNumber = LevelNumber + 1
            WorldManager:load()
            LevelManager:loadLevel(LevelNumber)
            if not LevelManager.hasLevel then
                love.event.quit(0)
            else
                Reset()
            end
            break
        end
    end
end

function love.draw()
    local background = love.graphics.newImage("images/background.png")
    love.graphics.setColor(1, 1, 1, 1) -- ensure full color and opacity
    love.graphics.draw(background, 0, 0)
    Countdown:draw()
    ScoreManager:draw()
    LevelManager:drawTiles()
    GhostManager:draw()
    Player:draw()
end

function love.keypressed(key)
    if key == "escape" then
        -- quit the game
        love.event.quit()
    end
    Player:keypressed(key)
    GhostManager:keypressed(key)
    Countdown:keypressed(key)
    SensorManager:keypressed(key)
end
