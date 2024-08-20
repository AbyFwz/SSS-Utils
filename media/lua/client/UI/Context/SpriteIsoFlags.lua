-- Function to add IsoFlags context menu
function SSS:addIsoFlagsContextMenu(contextMenu, object, title)
    -- Get properties of the object
    local properties = object and object:getProperties()

    -- Check if properties exist
    if properties then
        -- Create a submenu for IsoFlags
        local mdMenu = SSS:addContextMenuSubMenu(contextMenu, title or "IsoFlags", {
            icon = SSS:getIconToItemId("Base.Glasses_Normal"),
        })

        -- Add debug option if in debug mode
        if getDebug() then
            SSS:addContextMenuItem(mdMenu, "[Debug] Make unbreakable", function()
                SSS.Movables:setUnbreakable(object, true)
            end)
        end

        -- Add flags to the context menu
        SSS:eachInCollection(properties:getFlagsList(), function(flag)
            SSS:addContextMenuItem(mdMenu, string.format("F: [%s] = [%s]", tostring(flag), tostring(properties:Val(tostring(flag)))))
        end)

        -- Add properties to the context menu
        SSS:eachInCollection(properties:getPropertyNames(), function(property)
            SSS:addContextMenuItem(mdMenu, string.format("P: [%s] = [%s]", tostring(property), tostring(properties:Val(tostring(property)))))
        end)
    end
end
