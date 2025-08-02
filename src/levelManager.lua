local platformFactory = require("src.platform")
local finishFactory = require("src.finish")

local levelManager = {}

levelManager.tileSize = 32 -- Each tile is 32 x 32 pixels
levelManager.tiles = {}    -- 2 dim array (table of tables) for storing tiles
levelManager.playerStart = nil
levelManager.finishPoints = {}
levelManager.levelFileInfo = nil


function levelManager:loadLevel(levelNumber)
  local filepath = "/levels/level-" .. levelNumber .. ".txt"
  self.levelFileInfo = love.filesystem.getInfo(filepath, "file")

  if not self.levelFileInfo then
    return
  end

  local levelWidth, levelHeight = love.graphics.getDimensions();
  local lines = {}

  -- Read lines from file in /levels directory. Filename must be of form 'level-<int>.txt'
  for line in love.filesystem.lines("/levels/level-" .. levelNumber .. ".txt") do
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
        levelManager.tiles[tileY][tileX] = tile                                           -- Add tile to tiles table
      else
        levelManager.tiles[tileY][tileX] = false                                          -- Need to explicitly mark as false
      end
    end
  end
end

function levelManager:drawTiles()
  for i, row in ipairs(self.tiles) do
    for j, tile in ipairs(row) do
      if tile then
        if tile.type == "Platform" or tile.type == "Finish" then
          tile:draw()
        end
      end
    end
  end
end

return levelManager
