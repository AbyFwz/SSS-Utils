-- Initialize SSS and TimerQueue
local SSS = SSS or {}
SSS.TimerQueue = SSS.TimerQueue or {}

SSS.TimerQueue.queueLength = 0

-- Debug logging function
function SSS.TimerQueue:debugLog(message)
    if getDebug() then
        print(message) -- Assuming print is the desired debug output
    end
end

SSS.TimerQueue["schedule"] = {};

-- Schedule a function to run after a certain time
function SSS.TimerQueue:waitUntil(amount, divisor, fn)
    local currentTime = Calendar.getInstance():getTimeInMillis()
    local targetTime = currentTime + (divisor * amount)

    -- Initialize the schedule for the target time if it doesn't exist
    SSS.TimerQueue["schedule"][targetTime] = SSS.TimerQueue["schedule"][targetTime] or {}
    table.insert(SSS.TimerQueue["schedule"][targetTime], fn)

    SSS.TimerQueue["queueLength"] = SSS.TimerQueue["queueLength"] + 1

    -- Start the timer if it's not already running
    if not SSS.TimerQueue["timerTickEvent"] then
        SSS.TimerQueue:startTimer()
    end

    return SSS.TimerQueue["schedule"][targetTime]
end

-- Count remaining items in the queue
function SSS.TimerQueue:countRemainingItems(full)
    if full then
        local total = 0
        for _, batchItems in pairs(SSS.TimerQueue["schedule"]) do
            total = total + #batchItems
        end
        return total
    end

    return SSS.TimerQueue:countArrayElements(SSS.TimerQueue["schedule"])
end

-- Check the status of the queue and start/stop the timer as needed
function SSS.TimerQueue:checkQueueStatus()
    SSS.TimerQueue["queueLength"] = SSS.TimerQueue:countRemainingItems(true)
    local itemsRemaining = SSS.TimerQueue["queueLength"] > 0

    if itemsRemaining and not SSS.TimerQueue["timerTickEvent"] then
        SSS.TimerQueue:debugLog("Starting timer (fallback event)")
        SSS.TimerQueue:startTimer()
    elseif not itemsRemaining and SSS.TimerQueue["timerTickEvent"] then
        SSS.TimerQueue:stopTimer("empty, fallback event")
    end
end

-- Start the timer if needed
function SSS.TimerQueue:startTimerIfNeeded()
    if SSS.TimerQueue["queueLength"] > 0 and not SSS.TimerQueue["timerTickEvent"] then
        SSS.TimerQueue:debugLog("Starting timer (fallback event)")
        SSS.TimerQueue:startTimer()
    end
end

-- Start the timer
function SSS.TimerQueue:startTimer()
    SSS.TimerQueue:debugLog("Starting timer")

    SSS.TimerQueue["timerTickEvent"] = function()
        if SSS.TimerQueue["queueLength"] > 0 then
            local currentTime = Calendar.getInstance():getTimeInMillis()

            for targetTime, taskFns in pairs(SSS.TimerQueue["schedule"]) do
                if currentTime >= targetTime then
                    for _, taskFn in ipairs(taskFns) do
                        taskFn()
                        SSS.TimerQueue["queueLength"] = SSS.TimerQueue["queueLength"] - 1
                    end

                    SSS.TimerQueue:debugLog(string.format("Time %s reached: executed batch of %d task(s). %d scheduled task(s) left.",
                        targetTime, #taskFns, SSS.TimerQueue["queueLength"]))

                    SSS.TimerQueue["schedule"][targetTime] = nil
                end
            end
        else
            SSS.TimerQueue:stopTimer("empty")
        end
    end

    Events.OnTick.Add(SSS.TimerQueue["timerTickEvent"])
end

-- Stop the timer if the queue is empty
function SSS.TimerQueue:stopTimerIfEmpty()
    if SSS.TimerQueue["queueLength"] == 0 then
        SSS.TimerQueue:stopTimer("empty")
    end
end

-- Stop the timer
function SSS.TimerQueue:stopTimer(reason)
    SSS.TimerQueue:debugLog(string.format("Stopping timer" .. (reason and " (reason: " .. reason .. ")" or " (no reason given)")))
    Events.OnTick.Remove(SSS.TimerQueue["timerTickEvent"])
    SSS.TimerQueue["timerTickEvent"] = nil
    SSS.TimerQueue["schedule"] = {}
end

-- Periodically check the queue status
Events.EveryTenMinutes.Add(function()
    SSS.TimerQueue:checkQueueStatus()
end)
