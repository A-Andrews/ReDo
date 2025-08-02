local WorldManager = require("src.worldManager")
local CollisionCategories = require("src.collisionCategories")

local levelManager = {}

local levelWidth, levelHieght = love.graphics.getDimensions();
print(levelWidth .. "x" .. levelHieght)
levelManager.tileSize = 32 -- Each tile is 32 x 32 pixels
levelManager.tiles = {}

function getChar(s, i)
  return string.sub(s, i)
end;

function levelManager:loadLevel(levelNumber)
  local lines = {}
  for line in love.filesystem.lines("/levels/level-" .. levelNumber .. ".txt") do
    table.insert(lines, tostring(line))
  end
  local lineCount = #lines
  if lineCount * self.tileSize ~= levelHieght then error("ahhh") end;
  for i, line in ipairs(lines) do
    if #line * self.tileSize ~= levelWidth then error("ahhh") end;
  end
  for i, line in ipairs(lines) do
    levelManager.tiles[i] = {}
    for j = 1, #line do
      local char = string.sub(line, j, j)
      -- for char in tostring(line):gmatch(".") do
      -- print("char" .. char)
      if char == "g" then
        local tile = {}
        tile.x = self.tileSize * (j - 1)
        tile.y = self.tileSize * (i - 1)
        tile.body = love.physics.newBody(WorldManager:getWorld(), tile.x, tile.y, "static")
        tile.shape = love.physics.newRectangleShape(self.tileSize, self.tileSize)
        tile.fixture = love.physics.newFixture(tile.body, tile.shape)
        tile.type = "Platform"
        tile.fixture:setUserData(tile)
        WorldManager:registerCollisionCallback(tile.fixture,
          {
            owner = tile,
            beginContact = tile.beginContact,
            endContact = tile.endContact
          })

        tile.fixture:setCategory(CollisionCategories.PLATFORM)
        levelManager.tiles[i][j] = tile  -- add tile to tiles table
      else
        levelManager.tiles[i][j] = false -- need to explicitly mark as false
      end
    end
    -- for j = 1, (levelWidth / self.tileSize) do
    --   print(line:sub(j))
    --   if string.sub(line, j) == "g" then
    --     print("ground")
    --   end
    -- end
    -- lineLength = #line
    -- if lineLength ~= levelWidth or
    --   error("bad level width and/or height")
    -- for i = 1, # line
    --   if char == "/" then

    --   end
    -- end
  end
end

function levelManager:drawTiles()
  for i, row in ipairs(self.tiles) do
    for j, tile in ipairs(row) do
      if tile then
        if tile.type == "Platform" then
          love.graphics.setColor(0.5, 0.5, 0.5)
          love.graphics.polygon("fill", tile.body:getWorldPoints(tile.shape:getPoints()))
          -- love.graphics.rectangle(
          --   "fill",
          --   tile.x,
          --   tile.y,
          --   self.tileSize,
          --   self.tileSize
          -- )
        end
      end
    end
  end
end

return levelManager
