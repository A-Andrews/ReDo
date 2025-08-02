local WorldManager = require("src.worldManager")
local CollisionCategories = require("src.collisionCategories")

local platformFactory = function(tileSize, tileX, tileY)
    local platform = {}

    function platform:load()
        self.x = (tileSize * (tileX - 1)) + (tileSize / 2)
        self.y = (tileSize * (tileY - 1)) + (tileSize / 2)
        self.body = love.physics.newBody(WorldManager:getWorld(), self.x, self.y, "static")
        self.shape = love.physics.newRectangleShape(tileSize, tileSize)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        self.type = "Platform"
        self.fixture:setUserData(self)
        WorldManager:registerCollisionCallback(self.fixture,
            {
                owner = self,
                beginContact = self.beginContact,
                endContact = self.endContact
            })

        self.fixture:setCategory(CollisionCategories.PLATFORM)
    end

    function platform:beginContact(other, coll)

    end

    function platform:endContact(other, coll)
    end

    function platform:update(dt)
        -- Update logic for the platform can be added here if needed
    end

    function platform:draw()
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    end

    return platform
end

return platformFactory
