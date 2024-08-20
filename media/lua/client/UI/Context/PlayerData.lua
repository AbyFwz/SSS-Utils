-- Function to add a player list context menu
function SSS:addPlayerListContextMenu(contextMenu, title, handler, customSortFn, plusUsername)
    -- Create a submenu for the player list
    local playerMenu = SSS:addContextMenuSubMenu(contextMenu, title)
    local onlinePlayers = SSS:getOnlinePlayers(not customSortFn)
    local player = SSS:getPlayer()
    local showAll = getDebug()

    -- Sort players if a custom sort function is provided
    if SSS:isFunction(customSortFn) then
        table.sort(onlinePlayers, customSortFn)
    end

    -- Add players to the context menu if there are multiple players or showAll is true
    if #onlinePlayers > 1 or showAll then
        for _, onlinePlayer in ipairs(onlinePlayers) do
            if onlinePlayer ~= player or showAll then
                local playerName = SSS:getPlayerName(onlinePlayer)
                local displayName = plusUsername and " [" .. onlinePlayer:getDisplayName() .. "]" or ""
                SSS:addContextMenuItem(playerMenu, playerName .. displayName, function()
                    if SSS:isFunction(handler) then
                        handler(onlinePlayer)
                    end
                end, { onlinePlayer })
            end
        end
    else
        -- Add a disabled item if there is only one player
        SSS:addContextMenuItem(playerMenu, getText("IGUI_SSS_ErrOnlyPlayer"), nil, nil, { disabled = true })
    end
end
