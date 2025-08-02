local platformFactory = require("src.platform")

local levelManager = {}

levelManager.tileSize = 32 -- Each tile is 32 x 32 pixels
levelManager.tiles = {}    -- 2 dim array (table of tables) for storing tiles
levelManager.playerStart = nil

function levelManager:loadLevel(levelNumber)
  local levelWidth, levelHieght = love.graphics.getDimensions();
  local lines = {}

  -- Read lines from file in /levels directory. Filename must be of form 'level-<int>.txt'
  for line in love.filesystem.lines("/levels/level-" .. levelNumber .. ".txt") do
    table.insert(lines, tostring(line))
  end

  -- Validate shape of level (line count and line lengths)
  local lineCount = #lines
  if lineCount * self.tileSize ~= levelHieght then error("ahhh") end;
  for i, line in ipairs(lines) do
    if #line * self.tileSize ~= levelWidth then error("ahhh") end;
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
        print("setting player start")
        self.playerStart = {
          start_x = (self.tileSize * (tileX - 1)) + (self.tileSize / 2),
          start_y = (self.tileSize * (tileY - 1)) + (self.tileSize / 2)
        }
      else
        levelManager.tiles[tileY][tileX] = false -- need to explicitly mark as false
      end
    end
  end
end

function levelManager:drawTiles()
  for i, row in ipairs(self.tiles) do
    for j, tile in ipairs(row) do
      if tile then
        if tile.type == "Platform" then
          tile:draw()
        end
      end
    end
  end
end

return levelManager
