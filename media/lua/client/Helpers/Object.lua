require "SSS_Utils_Client"

-- Execute a function once per object
function SSS:executeOncePerObject(object, fn)
    if object ~= SSS.lastExecObj then
        fn()
    end
    SSS.lastExecObj = object
end

-- Set mod data for an object and transmit it
function SSS:setObjectModData(object, key, value)
    object:getModData()[key] = value
    object:transmitModData()
end

-- Get the movable name from an object
function SSS:getMovableNameFromObject(object)
    local moveProps = ISMoveableSpriteProps.fromObject(object)
    return moveProps and Translator.getMoveableDisplayName(moveProps.name) or SSS:getObjectSpriteName(object)
end
