require "SSS_Utils_Shared"

-- Function to check if the time was less than X minutes ago
function SSS:timeWasLessThanXMinutesAgo(compTS, mins)
    return not SSS:timeWasMoreThanXMinutesAgo(compTS, mins)
end

-- Function to check if the time was more than X minutes ago
function SSS:timeWasMoreThanXMinutesAgo(compTS, mins)
    return ((SSS:getTimestamp() - compTS) / 60000) > mins
end

-- Function to check if the time was more than X seconds ago
function SSS:timeWasMoreThanXSecondsAgo(compTS, secs)
    return ((SSS:getTimestamp() - compTS) / 1000) > secs
end

-- Function to add a delay before executing a function
function SSS:waitUntil(amount, divisor, fn)
    if SSS:getSandboxVar("UseBaseTimerQueue") then
        return SSS.TimerQueue:waitUntil(amount, divisor, fn)
    else
        SSS.waitTimers = SSS.waitTimers or {}

        local targetTime = (SSS:getTimestamp() / divisor) + amount
        local timerId = #SSS.waitTimers + 1

        SSS.waitTimers[timerId] = function()
            if SSS:getTimestamp() / divisor >= targetTime then
                Events.OnTick.Remove(SSS.waitTimers[timerId])
                SSS.waitTimers[timerId] = nil
                fn()
            end
        end

        Events.OnTick.Add(SSS.waitTimers[timerId])
        return SSS.waitTimers[timerId]
    end
end

-- Function to add a delay in seconds before executing a function
function SSS:waitSecondsUntil(seconds, fn)
    SSS:waitUntil(seconds, 1000, fn)
end

-- Function to execute a function as soon as possible
function SSS:waitAndDoASAP(fn)
    SSS:waitUntil(1, 1, fn)
end

-- Function to get the in-game time as a string
function SSS:getIngameTimeStr()
    local gameTime = getGameTime()
    return string.format("%d-%02d-%02d %02d:%02d", gameTime:getYear(), gameTime:getMonth() + 1, gameTime:getDay() + 1, gameTime:getHour(), gameTime:getMinutes())
end

-- Function to set the in-game time by day, month, and year
function SSS:setGameTimeDMY(d, m, y)
    local gameTime = getGameTime()
    gameTime:setDay(d)
    gameTime:setMonth(m)
    gameTime:setYear(y)
    return gameTime
end

-- Function to get the current timestamp
function SSS:getTimestamp()
    return Calendar.getInstance():getTimeInMillis()
end

-- Function to get the current time as a string
function SSS:getTimeString()
    return Calendar.getInstance():getTime()
end
