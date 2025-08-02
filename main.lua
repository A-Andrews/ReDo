local WorldManager = require("src.worldManager")
local Platform = require("src.platform")
local LevelManager = require("src.levelManager")
local Player = require("src.player")
local GhostManager = require("src.ghostManager")
local Countdown = require("src.countdown")
local ScoreManager = require("src.scoreManager")
local MovingPlatformManager = require("src.movingPlatformManager")

local LevelNumber = 1 -- level number (starts at 1 and increments)

function love.load()
    WorldManager:load()
    LevelManager:loadLevel(LevelNumber)
    Countdown:load()
    ScoreManager:load()
    Player:load()
    GhostManager:load()
    MovingPlatformManager:load()
end

function love.update(dt)
    WorldManager:update(dt)
    Countdown:update(dt)
    Player:update(dt)
    GhostManager:update(dt)
    MovingPlatformManager:update(dt)

    -- Placeholder logic for moving between levels
    for i, point in ipairs(LevelManager.finishPoints) do
        if ((Player.physicsEntity.box:getX() - point.finishX) ^ 2 + (Player.physicsEntity.box:getY() - point.finishY) ^ 2) < 1000 then
            print("Level complete!")
            LevelNumber = LevelNumber + 1
            WorldManager:load()
            LevelManager:loadLevel(LevelNumber)
            if not LevelManager.levelFileInfo then
                print("Game completed!")
                love.event.quit(0)
            else
                Countdown:load()
                ScoreManager:load()
                Player:load()
                GhostManager:load()
            end
            break
        end
    end
end

function love.draw()
    Countdown:draw()
    ScoreManager:draw()
    LevelManager:drawTiles()
    Player:draw()
    GhostManager:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    Player:keypressed(key)
    GhostManager:keypressed(key)
    Countdown:keypressed(key)
end
