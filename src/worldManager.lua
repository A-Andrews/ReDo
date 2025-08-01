local WorldManager = {}

function WorldManager:load()
    local gravity = 35
    love.physics.setMeter(64)
    self.world = love.physics.newWorld(0, gravity * 64, true)
    self.collisionCallbacks = {}
    self.world:setCallbacks(
    function(a, b, coll)
        self:beginContact(a, b, coll)
    end,
    function(a, b, coll)
        self:endContact(a, b, coll)
        end,
    function (a, b, coll)
        self:preSolve(a, b, coll)
    end)
end

function WorldManager:preSolve(a, b, coll)
    local callbackFixtureA = self.collisionCallbacks[a]
    if callbackFixtureA and callbackFixtureA.preSolve then
        callbackFixtureA.owner:preSolve(b, coll)
    end

    local callbackFixtureB = self.collisionCallbacks[b]
    if callbackFixtureB and callbackFixtureB.preSolve then
        callbackFixtureB.owner:preSolve(a, coll)
    end
end

function WorldManager:beginContact(a, b, coll)
    local callbackFixtureA = self.collisionCallbacks[a]
    if callbackFixtureA and callbackFixtureA.beginContact then
        callbackFixtureA.owner:beginContact(b, coll)
    end

    local callbackFixtureB = self.collisionCallbacks[b]
    if callbackFixtureB and callbackFixtureB.beginContact then
        callbackFixtureB.owner:beginContact(a, coll)
    end
end

function WorldManager:endContact(a, b, coll)
    local callbackFixtureA = self.collisionCallbacks[a]
    if callbackFixtureA and callbackFixtureA.endContact then
        callbackFixtureA.owner:endContact(b, coll)
    end

    local callbackFixtureB = self.collisionCallbacks[b]
    if callbackFixtureB and callbackFixtureB.endContact then
        callbackFixtureB.owner:endContact(a, coll)
    end
end

function WorldManager:registerCollisionCallback(fixture, callback)
    self.collisionCallbacks[fixture] = callback
end

function WorldManager:getWorld()
    return self.world
end

function WorldManager:update(dt)
    self.world:update(dt)
end

return WorldManager
