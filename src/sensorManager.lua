local sensorManager = {}

sensorManager.sensors = {} -- Array of sensor tiles

function sensorManager:AddSensor(sensor)
    table.insert(self.sensors, sensor)
end

function sensorManager:allActive()
    local result = true
    if #self.sensors == 0 then
        return result
    end
    for i, sensor in ipairs(self.sensors) do
        if not sensor.activated then
            result = false
        end
    end
    return result
end

function sensorManager:update(dt, bodies)
    for i, sensor in ipairs(self.sensors) do
        sensor:update(dt, bodies)
    end
end

return sensorManager
