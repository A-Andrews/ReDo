-- Configuration
local audioFileNames = {
    "MusicBox Version.ogg",
    "MusicBox Version with Bass.ogg",
    "MusicBox Version With Piano.ogg",
    "MusicBox Version With Bass drum and synth.ogg",
    "Synth Version.ogg",
    "Synth Version Higher Pitch.ogg",
    "Synth Version Higher Pitch +.ogg",
    "Synth Version +.ogg"
}

local currentIndex = 1
local currentSound = nil
local audioLayers = {}

-- Load Audio
function love.load()
    for _, filename in ipairs(audioFileNames) do
        local sound = love.audio.newSource(filename, "static")
        sound:setLooping(true)
        table.insert(audioLayers, sound)
    end
end

function love.draw()
    love.graphics.print("Current Track: " .. currentIndex .. " / " .. #audioLayers, 10, 10)
    love.graphics.print("Press SPACE to progress, R to reset", 10, 30)
end

function love.keypressed(key)
    if key == "space" then
        advanceTrack()
    elseif key == "r" then
        resetAll()
    end
end

-- Play next track, stopping the previous
function advanceTrack()
    if currentSound then
        currentSound:stop()
    end

    if currentIndex <= #audioLayers then
        currentSound = audioLayers[currentIndex]
        currentSound:play()
        currentIndex = currentIndex + 1
    end
end

-- Reset to beginning
function resetAll()
    if currentSound then
        currentSound:stop()
        currentSound = nil
    end
    currentIndex = 1
end
