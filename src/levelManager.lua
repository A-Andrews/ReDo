local platformFactory = require("src.platform")
local finishFactory = require("src.finish")
local Sensor = require("src.sensor")
local MovingPlatform = require("src.movingPlatform")
local MovingPlatformManager = require("src.movingPlatformManager")
local Spikes = require("src.spikes")
local Countdown = require("src.countdown")

local levelManager = {}

levelManager.tileSize = 32 -- Each tile is 32 x 32 pixels
levelManager.tiles = {}    -- 2 dim array (table of tables) for storing tiles
levelManager.playerStart = nil
levelManager.finishPoints = {}
levelManager.levelFileInfo = nil


function levelManager:loadLevel(levelNumber)
    local fileDataPath = "/levels/level-" .. levelNumber .. ".data.txt"
    self.levelDataFileInfo = love.filesystem.getInfo(fileDataPath, "file")

    local fileMapPath = "/levels/level-" .. levelNumber .. ".txt"
    self.levelMapFileInfo = love.filesystem.getInfo(fileMapPath, "file")

    if self.levelMapFileInfo and self.levelDataFileInfo then
        self.hasLevel = true
    else
        self.hasLevel = false
    end;

    if not self.levelMapFileInfo or not self.levelDataFileInfo then
        return
    end

    local dataLines = {}
    for line in love.filesystem.lines(fileDataPath) do
        table.insert(dataLines, tostring(line))
    end
    local dataKeys = {}
    local dataValues = {}
    for i, line in ipairs(dataLines) do
        print(line)
        for match in line:gmatch("([^,]+?)") do
            print(match)
            if i == 1 then
                table.insert(dataKeys, match)
            else
                table.insert(dataValues, match)
            end
        end;
    end
    Countdown.duration = dataKeys.time

    local levelWidth, levelHeight = love.graphics.getDimensions();
    local lines = {}

    -- Read lines from file in /levels directory. Filename must be of form 'level-<int>.txt'
    for line in love.filesystem.lines(fileMapPath) do
        table.insert(lines, tostring(line))
    end

    -- Validate shape of level (line count and line lengths)
    local lineCount = #lines
    if lineCount * self.tileSize ~= levelHeight then
        error("Text file for level " .. levelNumber .. " has incorrect number of rows")
    end;
    for i, line in ipairs(lines) do
        if #line * self.tileSize ~= levelWidth then
            error("Text file for level " .. levelNumber .. " has incorrect width on line " .. i)
        end;
    end

    -- Parse lines and populate tiles table
    for tileY, line in ipairs(lines) do
        levelManager.tiles[tileY] = {}
        for tileX = 1, #line do
            local char = string.sub(line, tileX, tileX)
            if char == "g" then
                local tile = platformFactory(self.tileSize, tileX, tileY)
                tile:load()
                levelManager.tiles[tileY][tileX] = tile -- add tile to tiles table
            elseif char == "x" then
                self.playerStart = {
                    startX = (self.tileSize * (tileX - 1)) + (self.tileSize / 2),
                    startY = (self.tileSize * (tileY - 1)) + (self.tileSize / 2)
                }
            elseif char == "f" then
                local tile = finishFactory(self.tileSize, tileX, tileY)
                tile:load()
                table.insert(levelManager.finishPoints, { finishX = tile.x, finishY = tile.y }) -- Add finish coordinates
                levelManager.tiles[tileY][tileX] =
                    tile                                                                        -- Add tile to tiles table
            elseif char == "s" then
                local sensor = Sensor:new(self.tileSize, tileX, tileY)
                levelManager.tiles[tileY][tileX] = sensor
            elseif char == "=" then
                local movingPlatform = MovingPlatform:new(self.tileSize, tileX, tileY)
                levelManager.tiles[tileY][tileX] = movingPlatform
                MovingPlatformManager:addMovingPlatform(movingPlatform) -- Add to moving platform manager
            elseif char == "^" then
                local spikes = Spikes:new(self.tileSize, tileX, tileY)
                levelManager.tiles[tileY][tileX] = spikes
            else
                levelManager.tiles[tileY][tileX] = nil -- Need to explicitly mark as false
            end
        end
    end
end

function levelManager:drawTiles()
    for i, row in pairs(self.tiles) do
        for j, tile in pairs(row) do
            if tile then
                tile:draw()
            end
        end
    end
end

return levelManager
