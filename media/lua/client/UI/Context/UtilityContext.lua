-- Determine version based on Steam Workshop item ID
local version = "nil" and "S" or "P"

-- Function to create the PA Tools context menu
function SSS:createPAToolsContextMenu(contextMenu, worldObjects)
    local player = SSS:getPlayer()

    -- Create the main admin menu
    local adminMenu = SSS:addContextMenuSubMenu(contextMenu, "SSS-Utility: " .. version .. "E", { icon = SSS.Icons["Utility"] })

    -- Create the debug tools submenu
    local debugMenu = SSS:addContextMenuSubMenu(adminMenu, getText("IGUI_SSS_DebugTools"))

    -- Add debug tools items
    SSS:addContextMenuItem(debugMenu, getText("IGUI_SSS_RegionDebugger"), IsoRegionsWindow.OnOpenPanel)
    SSS:addContextMenuItem(debugMenu, getText("IGUI_SSS_ZombieDebugger"), ZombiePopulationWindow.OnOpenPanel)

    -- Add vehicle mod data if a vehicle is nearby
    local vehicle = SSS:getClosestVehicle(player)
    if vehicle then
        SSS:addModDataContextMenu(debugMenu, vehicle, getText("IGUI_SSS_ObjectModData", SSS:getVehicleName(vehicle)))
    end

    -- Track processed objects to avoid duplicates
    local processedObjects = {}
    for _, object in ipairs(worldObjects) do
        if not SSS:valueIsInArray(processedObjects, object) then
            local objectName = SSS:getObjectSpriteName(object) or "?"

            -- Add object mod data and ISO flags to the context menu
            SSS:addModDataContextMenu(debugMenu, object, getText("IGUI_SSS_ObjectModData", objectName), true)
            SSS:addIsoFlagsContextMenu(debugMenu, object, getText("IGUI_SSS_ObjectIsoFlags", objectName))

            table.insert(processedObjects, object)
        end
    end

    -- Execute hooks for additional context menu items
    for _, hook in ipairs(SSS.Hooks:get("UtilityContext")) do
        hook(adminMenu, worldObjects)
    end

    return contextMenu
end

-- Event handler to fill the world object context menu
Events.OnFillWorldObjectContextMenu.Add(function(player, contextMenu, worldObjects)
    if SSS:playerIsGMPlus() then
        SSS:createPAToolsContextMenu(contextMenu, worldObjects)
    end
end)
