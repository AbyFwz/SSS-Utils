require "SSS_Utils_Client"

-- Get the current player
function SSS:getPlayer()
    return SSS.currentPlayer or getPlayer()
end

-- Save player mod data (currently commented out)
function SSS:savePlayerModData(player)
    -- Uncomment and modify as needed
    -- player = player or SSS:getPlayer()
    -- SSS:log("Saving player moddata:")
    -- SSS:logArray(player:getModData() or {})
    -- SSS:saveModData(player or SSS:getPlayer())
end

-- Say a message with optional parameters
function SSS:say(message, player, r, g, b, radius, sType)
    player = player or SSS:getPlayer()

    -- Add message to the queue
    SSS.MessageQueue:add(function()
        SSS:sayHaloMessage(message, player, r, g, b)
    end)

    if SSS.debugSay then
        print(string.format("SSS:say(%s, %s, %s, %s, %s, %s, %s)",
            tostring(message), tostring(player:getDisplayName()),
            tostring(r), tostring(g), tostring(b),
            tostring(radius), tostring(sType)))
    end
end

-- Say a halo message
function SSS:sayHaloMessage(message, player, r, g, b)
    player = player or SSS:getPlayer()
    player:setHaloNote(SSS:translateIfNeeded(message), (r or SSS.speechR) * 255, (g or SSS.speechG) * 255, (b or SSS.speechB) * 255, 300)
end

-- Say a message in color
function SSS:sayInColor(message, r, g, b, radius, sType)
    local color = r and g and b and SSS:transformColor(r, g, b) or {}

    if SSS.debugSay then
        print(string.format("SSS:sayInColor(%s, %s, %s, %s, %s, %s)",
            tostring(message), tostring(SSS:getPlayer():getDisplayName()),
            tostring(r or 1), tostring(g or 1), tostring(b or 1),
            tostring(radius), tostring(sType)))
    end

    SSS:say(SSS:translateIfNeeded(message), SSS:getPlayer(), color.r or 1, color.g or 1, color.b or 1, radius, sType)
end

-- Say a success message
function SSS:saySuccess(message)
    SSS:sayInColor(message, 119, 221, 119)
end

-- Say a success message without queue
function SSS:saySuccessNoQueue(message)
    SSS:sayHaloMessage(message, SSS:getPlayer(), 119, 221, 119)
end

-- Say an error message
function SSS:sayError(message)
    SSS:sayInColor(message, 255, 87, 87)
end

-- Say a message if the object is different from the last one
function SSS:sayIfDifferentObject(object, message, player)
    if object ~= SSS.lastErrorObj then
        SSS:say(message, player or SSS:getPlayer())
    end
    SSS.lastErrorObj = object
end

-- Say an error message if chat is not enabled
function SSS:sayErrorIfNoChat(message)
    if SSS:chatIsEnabled() then
        SSS.Chat:addErrorLine(message)
    else
        SSS:sayError(message)
    end
end

-- Check if the user is restricted
function SSS:userIsRestricted()
    if not SSS:gameIsSP() then
        local accessLevel = getAccessLevel()
        return not accessLevel or accessLevel == "" or accessLevel:lower() == "none"
    end
    return false
end

-- Check if the player is Overseer or higher
function SSS:playerIsOverseerPlus()
    return SSS:accessLevelIsOnList({ "Overseer", "overseer", "Moderator", "moderator", "Admin", "admin" })
end

-- Check if the player is GM or higher
function SSS:playerIsGMPlus()
    return SSS:accessLevelIsOnList({ "GM", "gm", "Overseer", "overseer", "Moderator", "moderator", "Admin", "admin" })
end

-- Check if the player is Moderator or higher
function SSS:playerIsModPlus()
    return SSS:accessLevelIsOnList({ "Moderator", "moderator", "Admin", "admin" })
end

-- Check if the player's access level is in the list
function SSS:accessLevelIsOnList(list)
    if not SSS:gameIsSP() then
        local accessLevel = getAccessLevel()
        for _, rank in ipairs(list) do
            if accessLevel == rank then
                return true
            end
        end
        return false
    else
        return true
    end
end

-- Check if the player is an admin
function SSS:playerIsAdmin()
    if not SSS:gameIsSP() then
        return isAdmin() or getAccessLevel():lower() == "admin"
    else
        return true
    end
end

-- Find a player in the cell by name
function SSS:findPlayerInCell(name, anyName)
    local matchFunc = anyName and function(player)
        return player:getDisplayName() == name or SSS:getPlayerName(player) == name
    end or function(player)
        return SSS:getPlayerName(player) == name
    end
    return SSS:findPlayerInCellBy(matchFunc)
end

-- Get an online player by name
function SSS:getOnlinePlayer(name)
    for _, oPlayer in ipairs(SSS:getOnlinePlayers()) do
        if oPlayer:getDisplayName() == name or SSS:getPlayerName(oPlayer) == name then
            return oPlayer
        end
    end
    return nil
end

-- Get the player's name
function SSS:getPlayerName(player)
    player = player or SSS:getPlayer()
    local modData = player:getModData()
    local name = SSS:trimString(SSS:getSandboxVar("UseRPNameIfPossible") and (modData and (modData.rpName or player:getFullName())) or player:getDisplayName())
    return (name and #name > 0 and name ~= " ") and name or player:getDisplayName()
end
