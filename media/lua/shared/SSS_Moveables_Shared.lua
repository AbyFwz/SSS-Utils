require "SSS_Hooks"

SSS = SSS or {}
SSS.Movables = SSS.Movables or {}

SSS.Movables.protectedSprites = SSS.Movables.protectedSprites or {}

-- Protection checks and overrides

function SSS.Movables:spriteIsProtected(spriteName)
    for _, protectedSprite in ipairs(SSS.Movables.protectedSprites) do
        if string.find(spriteName, protectedSprite, 1, true) then
            --print("PROTECTED: Sprite [" .. tostring(spriteName) .. "] is on the protected list")
            return true
        end
    end
    return false
end

function SSS.Movables:protectionIsVetoed(object, spriteName, mode, source)
    -- Override / veto depending on sprite name
    if spriteName then
        for _, hookFn in ipairs(SSS.Hooks:get("spriteIsNotProtected")) do
            if hookFn(spriteName, mode, object, source) == true then
                --print("VETO: Sprite [" .. tostring(spriteName) .. "] had a hook return true")
                return true
            end
        end
    end

    -- Override / veto depending on object
    if object then
        for _, hookFn in ipairs(SSS.Hooks:get("objectIsNotProtected")) do
            if hookFn(object, mode, spriteName, source) == true then
                --print("VETO: Object [" .. tostring(object) .. "] had a hook return true")
                return true
            end
        end
    end

    return false
end

function SSS.Movables:protectionWasTriggeredByHooks(object, spriteName, mode, source)
    -- Additional sprite checks
    if spriteName then
        for _, hookFn in ipairs(SSS.Hooks:get("spriteIsProtected")) do
            if hookFn(spriteName, mode, object, source) == true then
                --print("PROTECTED: Sprite [" .. tostring(spriteName) .. "] had a hook return true")
                return true
            end
        end
    end

    -- Additional object checks
    if object then
        for _, hookFn in ipairs(SSS.Hooks:get("objectIsProtected")) do
            if hookFn(object, mode, spriteName, source) == true then
                --print("PROTECTED: Object [" .. tostring(object) .. "] had a hook return true")
                return true
            end
        end
    end

    return false
end

-- Main function to determine destructive events

function SSS.Movables:objectIsProtected(object, mode, spriteName, source)
    -- Staff can do everything
    if not SSS:userIsRestricted() then
        return false
    end

    if object and object.getSprite and object:getSprite() then
        spriteName = object:getSprite():getName()
    end

    -- Override / veto by hooks
    if SSS.Movables:protectionIsVetoed(object, spriteName, mode, source) then
        return false
    end

    -- Checking registered sprites
    if spriteName and SSS.Movables:spriteIsProtected(spriteName) then
        if source ~= "ISWorldMenuElements_ContextDisassemble" then
            SSS:sayHaloMessage(getText("IGUI_SSS_ErrNoPickup"))
        end
        return true
    end

    -- Additional protection checks done by hooks
    if SSS.Movables:protectionWasTriggeredByHooks(object, spriteName, mode, source) then
        return true
    end

    return false
end

-- Register sprite name as protected (from within other mods)

function SSS.Movables:registerProtectedSprite(spriteName)
    if not SSS.Movables.protectedSprites then
        SSS.Movables.protectedSprites = {}
    end

    SSS:insertIfNotInArray(SSS.Movables.protectedSprites, spriteName)

    SSS:log(SSS:getSCPrefix() .. 'Registering protected sprite name: ["' .. tostring(spriteName) .. '"]')
    SSS:logStackTraceOrigin()

    return SSS.Movables.protectedSprites
end

-- Data set by SSS -> container context menu

function SSS.Movables:objectHasContainerModData(object, modData)
    modData = modData or object:getModData()

    for _, key in ipairs({
        "isSSS_vending_overridden", "dropboxOwner", "readonly",
    }) do
        if modData[key] ~= nil then
            --SSS:log("Object " .. tostring(SSS:getObjectSpriteName(object) or object) .. " at " .. SSS:getObjectPositionString(object) .. " is protected: vending machine / dropbox / readonly")
            return true
        end
    end

    return false
end

-- Make something unbreakable (client side at least)

function SSS.Movables:setUnbreakable(object, state, setModData)
    SSS:log("Setting object " .. tostring(object) .. " at " .. SSS:getObjectPositionString(object) .. " indestructible: " .. tostring(state))

    state = not state

    if object.setIsDismantable then
        --SSS:log(" - setIsDismantable(" .. tostring(state) .. ")")
        object:setIsDismantable(state)
    end

    if object.setIsThumpable then
        --SSS:log(" - setIsThumpable(" .. tostring(state) .. ")")
        object:setIsThumpable(state)
    end

    if state and object.setThumpDmg then
        --SSS:log(" - setThumpDmg(0)")
        object:setThumpDmg(0)
    end

    if setModData ~= false then
        object:getModData().indestructible = state and true or nil

        if isClient() then
            object:transmitModData()
        end
    end

    local properties = object:getProperties()

    if properties then
        for _, property in ipairs({
            "CanBreak", "CanScrap",
        }) do
            if state then
                properties:Set(property, value)
            else
                properties:UnSet(property)
            end
        end

        properties:CreateKeySet()
    end
end
