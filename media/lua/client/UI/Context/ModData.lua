-- Function to add ModData context menu
function SSS:addModDataContextMenu(contextMenu, object, title, omitIfNone)
    -- Determine modData based on object type
    local modData = type(object) ~= "table" and object:getModData() or object

    -- Check if modData exists and has elements
    if modData and SSS:countArrayElements(modData) > 0 then
        -- Create a submenu for ModData
        local mdMenu = SSS:addContextMenuSubMenu(contextMenu, title or "ModData", {
            icon = SSS:getIconToItemId("Base.Glasses_Normal"),
        })

        -- Add debug information if in debug mode and object has special container ModData
        if getDebug() and SSS.Movables:objectHasContainerModData(object, modData) then
            SSS:addContextMenuItem(mdMenu, "[Debug] Object has special container ModData")
        end

        -- Iterate through modData and add items to the context menu
        for key, value in pairs(modData) do
            if type(value) ~= "table" then
                SSS:addContextMenuItem(mdMenu, string.format("[%s] = [%s]", tostring(key), tostring(value)))
            else
                SSS:addModDataContextMenu(mdMenu, value, string.format("[%s]", tostring(key)))
            end
        end
    elseif not omitIfNone then
        -- Add a header indicating no ModData if omitIfNone is false
        SSS:addContextMenuHeader(contextMenu, getText("IGUI_SSS_ErrNoModData"))
    end
end
