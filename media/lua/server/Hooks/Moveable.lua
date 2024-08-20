require "BuildingObjects/ISDestroyCursor"
require "BuildingObjects/ISMoveableCursor"

local destroyCursorCanDestroy = ISDestroyCursor.canDestroy

ISDestroyCursor.canDestroy = function(self, object)
    if SSS.Movables:objectIsProtected(object, "scrap", nil, "ISDestroyCursor_canDestroy") then
        return false
    end
    return destroyCursorCanDestroy(self, object)
end

local movCursorValid = ISMoveableCursor.isValid

ISMoveableCursor.isValid = function(self, square)
    local result = movCursorValid(self, square)

    if ISMoveableCursor.mode[self.player] ~= "place" then
        local objects = self.objectListCache or self:getObjectList()
        local object = #objects > 0 and objects[self.objectIndex] or (mode == "rotate" and self:getRotateableObject())

        if object and object.object and SSS.Movables:objectIsProtected(object.object, ISMoveableCursor.mode[self.player], nil, "ISMoveableCursor_isValid") then
            return false
        end
    end

    return result
end
