require "SSS_Utils_Shared"

-- Player-related functions

-- Get a list of online players' names
function SSS:getOnlinePlayersNameList()
    return SSS:getOnlinePlayers(false, true)
end

-- Get a list of online players, optionally sorted and/or only names
function SSS:getOnlinePlayers(sorted, onlyNames)
    local onlinePlayers = getOnlinePlayers()
    local playerList = {}

    if onlinePlayers then
        for i = 0, onlinePlayers:size() - 1 do
            local onlinePlayer = onlinePlayers:get(i)
            if onlinePlayer then
                table.insert(playerList, onlyNames and onlinePlayer:getDisplayName() or onlinePlayer)
            end
        end
    end

    if sorted then
        table.sort(playerList, function(a, b)
            return SSS:getFirstLetter(a:getUsername()) < SSS:getFirstLetter(b:getUsername())
        end)
    end

    return playerList
end

-- Get an online player by username
function SSS:getOnlinePlayerByName(username)
    local onlinePlayers = getOnlinePlayers()
    if onlinePlayers then
        for i = 0, onlinePlayers:size() - 1 do
            local onlinePlayer = onlinePlayers:get(i)
            if onlinePlayer and onlinePlayer:getUsername() == username then
                return onlinePlayer
            end
        end
    end
    return nil
end

-- Find a player in the cell by username
function SSS:findPlayerInCellByUsername(username)
    return SSS:findPlayerInCellBy(function(player)
        return player:getDisplayName() == username
    end)
end

-- Find a player in the cell by a custom check function
function SSS:findPlayerInCellBy(checkFn)
    local objects = getCell():getObjectList()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if instanceof(object, "IsoPlayer") and checkFn(object) then
            return object
        end
    end
    return nil
end

-- Get the distance between two players
function SSS:getDistanceBetweenPlayers(player1, player2)
    return player1:getSquare():DistToProper(player2:getSquare())
end

-- Execute a function if a user is online
function SSS:doIfUserIsOnline(username, whatDo)
    local targetPlayer = SSS:getOnlinePlayerByName(username)
    if targetPlayer and SSS:isFunction(whatDo) then
        whatDo(targetPlayer)
        return true
    end
    return false
end

-- Get the faction of a player
function SSS:getPlayerFaction(player)
    player = player or SSS:getPlayer()
    local username = player:getUsername()
    local factions = Faction:getFactions()

    for i = 0, factions:size() - 1 do
        local faction = factions:get(i)
        if faction and (faction:isMember(username) or faction:isOwner(username)) then
            return faction
        end
    end
    return nil
end

-- Apply a function to each online player
function SSS:eachOnlinePlayer(fn)
    local onlinePlayers = getOnlinePlayers()
    if onlinePlayers then
        for i = 0, onlinePlayers:size() - 1 do
            local onlinePlayer = onlinePlayers:get(i)
            if onlinePlayer then
                fn(onlinePlayer)
            end
        end
    end
end

-- Sort players by their names
function SSS.sortPlayersFn(a, b)
    return SSS:getFirstLetter(SSS:getPlayerName(a)) < SSS:getFirstLetter(SSS:getPlayerName(b))
end

-- Get the position of a player as a string or array
function SSS:getPlayerPosition(player, asArray, asNumbers)
    player = player or SSS:getPlayer()
    local position = {
        math.floor(player:getX()),
        math.floor(player:getY()),
        math.floor(player:getZ())
    }

    if not asNumbers then
        for i = 1, #position do
            position[i] = tostring(position[i])
        end
    end

    return asArray and position or table.concat(position, ",")
end

-- Check if a player is a member of a safehouse
function SSS:playerIsSafehouseMember(safehouse, player)
    return safehouse and safehouse:getPlayers():contains(player:getUsername())
end
