local requestCounts = {}
local RATE_LIMIT = 10 -- Max requests per minute

function handleRequest(player, request)
    local playerID = player:getID()
    local currentTime = os.time()

    if not requestCounts[playerID] then
        requestCounts[playerID] = {count = 0, timestamp = currentTime}
    end

    local timeDiff = currentTime - requestCounts[playerID].timestamp

    if timeDiff > 60 then
        requestCounts[playerID].count = 0
        requestCounts[playerID].timestamp = currentTime
    end

    if requestCounts[playerID].count < RATE_LIMIT then
        requestCounts[playerID].count = requestCounts[playerID].count + 1
        -- Process the request
    else
        -- Reject the request
        player:sendMessage("Rate limit exceeded. Please try again later.")
    end
end
