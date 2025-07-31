local Platform = require("src.platform")
local Player = require("src.player")
local GhostManager = require("src.ghostManager")
local Levels = {}
local LevelNumber = 0
local Level

function love.load()
    love.physics.setMeter(64)
    World = love.physics.newWorld(0, 9.81 * 64, true)
    for i = 1, 2 do
        local level = love.filesystem.load('levels/level-' .. i .. '.lua')
        table.insert(Levels, level)
    end
    LevelNumber = 1
    Level = Levels[LevelNumber]()
    Level:load()
    Platform:load()
    Player:load()
    GhostManager:load()
end

function love.update(dt)
    World:update(dt)
    Level:update(dt)
    Platform:update(dt)
    Player:update(dt)
    GhostManager:update(dt)
    if ((Player.x - Level.endloc[1]) ^ 2 + (Player.y - Level.endloc[2]) ^ 2) < 1000 then
        print("Level complete!")
        LevelNumber = LevelNumber + 1
        Level = Levels[LevelNumber]
        if not Level then
            print("Game completed!")
            love.event.quit(0)
        else
            Level = Level()
            Level:load()
            Player:load()
        end
    end
end

function love.draw()
    if Level then
        Level:draw()
    end
    Platform:draw()
    Player:draw()
    GhostManager:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    Player:keypressed(key)
    GhostManager:keypressed(key)
end
