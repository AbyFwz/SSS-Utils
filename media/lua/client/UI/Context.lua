require "SSS_Utils_Client"

SSS.cachedMenuItems = SSS.cachedMenuItems or {}

-- Function to add a context menu item
function SSS:addContextMenuItem(context, text, handler, params, options)
    return SSS:createContextMenuOption(context, text, handler, params, SSS:mergeArrays({ isSubMenu = false }, options))
end

-- Function to add a context menu header
function SSS:addContextMenuHeader(context, text, handler, params, options)
    return SSS:addContextMenuItem(context, text, handler, params, SSS:mergeArrays({ disabled = true }, options))
end

-- Function to add a context menu sub-menu
function SSS:addContextMenuSubMenu(context, text, handler, params, options)
    if type(handler) == "table" then
        options = handler
        params = nil
        handler = nil
    end
    return SSS:createContextMenuOption(context, text, handler, params, SSS:mergeArrays({ isSubMenu = true }, options))
end

-- Function to create a context menu option
function SSS:createContextMenuOption(context, text, handler, params, options)
    -- Check if context is valid
    if not context then
        return {
            addOption = function() end,
            addSubMenu = function() end,
            options = {},
        }
    end

    -- Initialize params if not provided
    if not params then
        params = {}
    end

    -- Add option to context menu
    local entry = context:addOption(
        text or nil,
        params[1] or nil,
        handler or nil,
        params[2] or nil,
        params[3] or nil,
        params[4] or nil,
        params[5] or nil,
        params[6] or nil
    )

    entry.notAvailable = options.disabled

    -- Add tooltip if provided
    if options.tip ~= nil then
        if type(options.tip) == "string" and options.tip ~= "" and string.sub(options.tip, 0, 5) ~= "IGUI_" then
            entry.toolTip = ISWorldObjectContextMenu.addToolTip()
            entry.toolTip.description = options.tip
        elseif type(options.tip) == "table" then
            entry.toolTip = options.tip
        end
    end

    -- Add icon if provided
    if options.icon then
        if type(options.icon) == "string" then
            entry.hoverIcon = string.gsub(options.icon, "%.png", "_hover.png")
            if entry.hoverIcon then
                entry.hoverIcon = getTexture(entry.hoverIcon)
                entry.hoverIcon = entry.hoverIcon or nil
            end
            entry.defaultIcon = getTexture(options.icon)
            options.icon = entry.defaultIcon
        end
        entry.iconTexture = options.icon
        entry.checkMark = nil
    else
        entry.checkMark = options.checked
    end

    -- Add sub-menu if specified
    if options.isSubMenu then
        local menu = ISContextMenu:getNew(context)
        context:addSubMenu(entry, menu)
        return menu
    else
        return entry
    end
end

-- Function to disable a context menu item
function SSS:disableContextMenuItem(contextMenu, optionText)
    for _, option in ipairs(contextMenu.options) do
        if string.find(option.name, optionText) then
            option.notAvailable = true
            return option
        end
    end
    return {}
end

-- Function to find a context menu option by name
function SSS:findContextMenuOptionByName(contextMenu, searchForName)
    for _, option in ipairs(contextMenu.options) do
        if string.find(option.name, searchForName) then
            return option
        end
    end
    return false
end

function SSS:createContextMenu(player, context, worldObjects)
    if not SSS.cachedMenuItems then
        SSS.cachedMenuItems = {}
        -- Create and cache menu items
        table.insert(SSS.cachedMenuItems, context:addOption("Option 1", player, nil))
        table.insert(SSS.cachedMenuItems, context:addOption("Option 2", player, nil))
    end

    -- Clear existing items
    context:clear()

    -- Add cached items to the context menu
    for _, item in ipairs(SSS.cachedMenuItems) do
        context:addOption(item)
    end

    -- Add dynamic items
    if someCondition then
        context:addOption("Dynamic Option 1", player, nil)
    else
        context:addOption("Dynamic Option 2", player, nil)
    end

    -- Add lazy loading option
    context:addOption("Load More Options", player, function()
        context:addOption("Lazy Loaded Option 1", player, nil)
        context:addOption("Lazy Loaded Option 2", player, nil)
    end)
end
