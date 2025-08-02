-- Configuration 
local audioFileNames = {
    "MusicBox Version With Bass drum and synth.ogg",
    "MusicBox Version with Bass.ogg",
    "MusicBox Version With Piano.ogg",
    "MusicBox Version.ogg",
    "Synth Version +.ogg",
    "Synth Version Higher Pitch +.ogg",
    "Synth Version Higher Pitch.ogg",
    "Synth Version.ogg"
}

local maxLayers = #audioFileNames
local audioLayers = {}
local playingLayers = {}
local loopCount = 0

-- Load Audio 
function love.load()
    for i, filename in ipairs(audioFileNames) do
        local sound = love.audio.newSource(filename, "static")
        sound:setLooping(true)
        table.insert(audioLayers, sound)
    end
end

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

    if not playingLayers[layerIndex] then
        local sound = audioLayers[layerIndex]
        sound:play()
        playingLayers[layerIndex] = true
    end
end

-- Reset All Loops and Audio 
function resetAll()
    for _, sound in ipairs(audioLayers) do
        sound:stop()
    end
    playingLayers = {}
    loopCount = 0
end
