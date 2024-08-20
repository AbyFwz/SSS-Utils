SSS = SSS or {}
SSS.Movables = SSS.Movables or {}
SSS.Movables.buildConfigs = SSS.Movables.buildConfigs or {}

-- Helper function to get object instance
function SSS.Movables:getObjectInstance(config)
    config.options = config.options or {}
    config.options.name = config.options.objectName or config.name

    local object
    if config.objectType == "double" then
        object = ISDoubleTileFurniture:new(config.options.name, table.unpack(config.sprites))
    elseif config.objectType == "single" then
        object = ISSimpleFurniture:new(config.options.name, table.unpack(config.sprites, 1, 2))
    end

    if object then
        object.name = config.options.name
        if config.containerType then
            object.containerType = config.containerType
            object.isContainer = true
        end

        object.completionSound = config.sound or "BuildMetalStructureMedium"
        object.noNeedHammer = true
        object.isThumpable = false
        object.dismantable = false

        if config.recipe then
            for key, mdKey in pairs({ materials = "need", skills = "xp" }) do
                if config.recipe[key] then
                    for k, v in pairs(config.recipe[key]) do
                        object.modData[mdKey .. ":" .. k] = v
                    end
                end
            end
        end

        for option, value in pairs(config.options) do
            if option ~= "group" and option ~= "objectName" then
                object[option] = value
            end
        end

        return object
    end

    return false
end

-- Function to register sprite
function SSS.Movables:registerSprite(name, sprites, options)
    table.insert(SSS.Movables.buildConfigs, SSS:mergeArrays({ name = name, sprites = sprites }, options))
end

-- Context menu creation
function SSS.Movables:createContextMenu(contextMenu, player)
    if #SSS.Movables.buildConfigs > 0 then
        local placeMenu = SSS:addContextMenuSubMenu(contextMenu, getText("IGUI_SSS_PlaceMovables"))
        local movGroups = {}

        player = player or SSS:getPlayer()

        for _, config in ipairs(SSS.Movables.buildConfigs) do
            local groupKey = config.group or "IGUI_SSS_MovNoGroup"
            movGroups[groupKey] = movGroups[groupKey] or {}
            table.insert(movGroups[groupKey], config)
        end

        for group, items in pairs(movGroups) do
            local groupMenu = SSS:addContextMenuSubMenu(placeMenu, getText(group))
            for _, config in ipairs(items) do
                local tip = " <H2> " .. config.name .. " <LINE> "
                if config.sprites[1] then
                    tip = tip .. " <IMAGE:" .. config.sprites[1] .. "> <LINE> "
                end

                SSS:addContextMenuItem(groupMenu, config.name, function()
                    local object = SSS.Movables:getObjectInstance(config)
                    if object then
                        getCell():setDrag(object, player:getPlayerNum())
                    end
                end, { config, player }, { tip = tip })
            end
        end
    end
end

-- Event handlers
Events.OnGameBoot.Add(function()
    SSS.Hooks:add("SSSContext", function(contextMenu, worldObjects)
        if SSS:playerIsAdmin() then
            SSS.Movables:createContextMenu(contextMenu)
        end
    end)
end)

Events.OnFillWorldObjectContextMenu.Add(function(player, contextMenu, worldObjects)
    if not SSS:userIsRestricted() and SSS.Hooks:exist("staffContainerContext") then
        local containers = {}
        local found = false

        for _, obj in ipairs(worldObjects) do
            if not containers[tostring(obj)] and SSS:objectIsContainer(obj) then
                containers[tostring(obj)] = obj
                found = true
            end
        end

        if found then
            local mainMenu = SSS:addContextMenuSubMenu(contextMenu, getText("IGUI_SSS_ContainersMenu"), {
                icon = SSS:getIconToItemId("Moveables.carpentry_01_19")
            })

            for _, container in pairs(containers) do
                local containerMenu = SSS:addContextMenuSubMenu(mainMenu, SSS:getMovableNameFromObject(container))

                -- Uncomment the following block if you want to enable tooltip highlighting
                --[[
                containerMenu.showTooltip = function(containerMenu, _option)
                    ISContextMenu.showTooltip(containerMenu, _option)
                    if container then
                        SSS:highlightObject(container)
                    end
                end
                ]]--

                for _, hookFn in ipairs(SSS.Hooks:get("staffContainerContext")) do
                    hookFn(containerMenu, worldObjects, container, containers)
                end
            end
        end
    end
end)
