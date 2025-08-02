-- Configuration 
local maxLayers = 10             -- Max number of audio layers
local audioLayers = {}           -- Preloaded audio tracks
local playingLayers = {}         -- Tracks which layers are currently playing
local loopCount = 0              -- How many loops have been added

-- Load Audio 
function love.load()
    for i = 1, maxLayers do
        local sound = love.audio.newSource("layer" .. i .. ".wav", "static")
        sound:setLooping(true)
        table.insert(audioLayers, sound)
    end
end

-- 
function love.draw()
    love.graphics.print("Loop Count: " .. loopCount, 10, 10)
    love.graphics.print("Playing Layers: " .. #playingLayers, 10, 30)
end

function love.keypressed(key)
    if key == "space" then
        addLoop()
    elseif key == "r" then
        resetAll()
    end
end

-- Add New Loop and Audio Layer 
function addLoop()
    loopCount = loopCount + 1
    local layerIndex = math.min(loopCount, maxLayers)

    -- Only play this layer if it hasn’t already started
    if not playingLayers[layerIndex] then
        local sound = audioLayers[layerIndex]
        sound:play()
        playingLayers[layerIndex] = true
    end

end

--  Reset All Loops and Audio 
function resetAll()
    for _, sound in ipairs(audioLayers) do
        sound:stop()
    end
    playingLayers = {}
    loopCount = 0
end









