require "SSS_Utils_Shared"

-- Get the sprite name of an object
function SSS:getObjectSpriteName(object)
    if object and object.getSprite then
        local sprite = object:getSprite()
        if sprite then
            return sprite:getName()
        end
    end
    return nil
end

-- Get the position of an object as a string in the format "x,y,z"
function SSS:getObjectPositionString(object)
    local x, y, z = object:getX(), object:getY(), object:getZ()
    return string.format("%d,%d,%d", math.floor(x), math.floor(y), math.floor(z))
end

-- Check if an object is a container
function SSS:objectIsContainer(object)
    return object and object.getContainerCount and object:getContainerCount() > 0
end

-- Check if an object is a door
function SSS:isDoor(object)
    return instanceof(object, "IsoDoor") or (instanceof(object, "IsoThumpable") and object:isDoor())
end

-- Check if an object is a window
function SSS:isWindow(object)
    return instanceof(object, "IsoWindow")
end
