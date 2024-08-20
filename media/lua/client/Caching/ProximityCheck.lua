-- Original Proximity Check
function SSS:checkProximity(player, objects, distance, fn)
    for _, obj in ipairs(objects) do
        if getDistance(player, obj) < distance then
            fn()
        end
    end
end

-- Optimized Proximity Check with Timer
local lastCheckTime = 0

function SSS:checkProximityWithTimer(player, objects, distance, checkInterval, fn)
    local currentTime = SSS:getTimestamp()
    if currentTime - lastCheckTime >= checkInterval then
        for _, obj in ipairs(objects) do
            if getDistance(player, obj) < distance then
                fn()
            end
        end
        lastCheckTime = currentTime
    end
end
