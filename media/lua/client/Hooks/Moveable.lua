require "Context/World/ISContextDisassemble"
require "Moveables/ISMoveablesAction"
require "TimedActions/ISDestroyStuffAction"

-- "disassemble" context menu on world object
local originalContextDisassemble = ISWorldMenuElements.ContextDisassemble

ISWorldMenuElements.ContextDisassemble = function(self)
    local context = originalContextDisassemble(self)
    local originalCreateMenu = context.createMenu

    context.createMenu = function(_data)
        for _, object in ipairs(_data.objects) do
            if SSS.Movables:objectIsProtected(object, "scrap", nil, "ISWorldMenuElements_ContextDisassemble") then
                return nil
            end
        end
        originalCreateMenu(_data)
    end

    return context
end

-- Main action for movables
local originalMovActionNew = ISMoveablesAction.new

ISMoveablesAction.new = function(self, playerObj, square, moveProps, mode, spriteName, cursor)
    local object = moveProps.object or cursor.cacheObject

    if mode ~= "place" and SSS.Movables:objectIsProtected(moveProps.object, mode, spriteName or "unknown sprite name", "ISMoveablesAction_new") then
        return ISBaseTimedAction:new(playerObj)
    end

    return originalMovActionNew(self, playerObj, square, moveProps, mode, spriteName, cursor)
end

local originalMovActionIsValid = ISMoveablesAction.isValid

ISMoveablesAction.isValid = function(self)
    local object = self.moveProps.object or self.moveCursor.cacheObject

    if self.mode ~= "place" and SSS.Movables:objectIsProtected(object, self.mode, self.origSpriteName or "unknown sprite name", "ISMoveablesAction_isValid") then
        return false
    end

    return originalMovActionIsValid(self)
end

local originalMovActionPerform = ISMoveablesAction.perform

ISMoveablesAction.perform = function(self)
    originalMovActionPerform(self)

    if SSS:getSandboxVar("LogMovableActions") then
        local name = self.origSpriteName or self.moveProps.spriteName

        SSS:logToServerFile(SSS.Paths.tileProtect .. tostring(self.mode or "unknown") .. ".log", string.format("%s %s [%s]: sprite [%s] at %s",
            getCurrentUserSteamID(), self.character:getDisplayName(), self.character:getAccessLevel(), name or "unknown sprite name", SSS:getObjectPositionString(self.square)
        ))
    end
end

local originalSledgePerform = ISDestroyStuffAction.perform

ISDestroyStuffAction.perform = function(self)
    local spriteName = SSS:getObjectSpriteName(self.item)

    originalSledgePerform(self)

    if SSS:getSandboxVar("LogMovableActions") then
        SSS:logToServerFile(SSS.Paths.tileProtect .. "destroy.log", string.format("%s %s [%s]: sprite [%s] at %s",
            getCurrentUserSteamID(), self.character:getDisplayName(), self.character:getAccessLevel(), spriteName or "unknown sprite name", SSS:getObjectPositionString(self.item)
        ))
    end

    for _, hookFn in ipairs(SSS.Hooks:get("objectDestroyedWithSledge")) do
        hookFn(self.item, spriteName or "unknown sprite name", self.sledge, self)
    end
end
