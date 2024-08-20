require "SSS_Hooks"
require "ISUI/ISWorldObjectContextMenu"

SSS = SSS or {}

-- Execute hooks with the already detected objects as parameters
local originalWorldContextCreateMenu = ISWorldObjectContextMenu.createMenu

ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
    local contextMenu = originalWorldContextCreateMenu(player, worldobjects, x, y, test)

    if not contextMenu or type(contextMenu) == "boolean" or test then
        return contextMenu
    end

    -- Uncomment if needed to fetch objects
    -- for _, object in ipairs(worldobjects) do
    --     ISWorldObjectContextMenu.fetch(object, player, true)
    -- end

    if clickedPlayer and SSS.Hooks:exist("playerContext") then
        local playerName = SSS:getPlayerName(clickedPlayer)
        for _, hookFn in ipairs(SSS.Hooks:get("playerContext")) do
            hookFn(contextMenu, worldobjects, clickedPlayer, playerName)
        end
    end

    if generator then
        for _, hookFn in ipairs(SSS.Hooks:get("generatorContext")) do
            hookFn(contextMenu, worldobjects, generator)
        end
    end

    if door then
        for _, hookFn in ipairs(SSS.Hooks:get("doorContext")) do
            hookFn(contextMenu, worldobjects, door)
        end
    end

    return contextMenu
end
