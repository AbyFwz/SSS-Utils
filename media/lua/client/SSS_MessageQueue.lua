require "SSS_Utils_Client"

SSS = SSS or {}
SSS.MessageQueue = {
    lastAt = Calendar.getInstance():getTimeInMillis(),
    timeInMs = 800,
    items = {}
}

-- Helpers
function SSS.MessageQueue:add(fn)
    table.insert(SSS.MessageQueue.items, fn)
    SSS.MessageQueue:check()
end

function SSS.MessageQueue:check()
    local currentTime = Calendar.getInstance():getTimeInMillis()

    if #SSS.MessageQueue.items > 0 and currentTime - SSS.MessageQueue.timeInMs >= SSS.MessageQueue.lastAt then
        table.remove(SSS.MessageQueue.items, 1)()
        SSS.MessageQueue.lastAt = currentTime
    end
end

-- Events
Events.OnPlayerUpdate.Add(function()
    SSS.MessageQueue:check()
end)
