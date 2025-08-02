local levelCompleteSound

function love.load()
    levelCompleteSound = love.audio.newSource("level_complete.wav", "static")
end


local levelCompleted = false
local soundPlayed = false

function love.update(dt)
    if playerHasFinishedLevel() and not levelCompleted then
        levelCompleted = true
    end

    if levelCompleted and not soundPlayed then
        love.audio.play(levelCompleteSound)
        soundPlayed = true
    end
end
