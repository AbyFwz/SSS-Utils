require "SSS_Utils_Shared"

-- Callbacks management
local callbacks = {}

-- Register a callback function and return its unique index
function SSS:registerCallback(fn)
    local index = tostring(ZombRand(0, 1989)) .. "_" .. tostring(getTimeInMillis())
    callbacks[index] = fn
    return index
end

-- Execute the callback function associated with the given index
function SSS:executeCallback(index)
    local callback = callbacks[index]
    if callback and SSS:isFunction(callback) then
        callback()
        SSS:discardCallback(index)
        return true
    end
    return false
end

-- Discard the callback function associated with the given index
function SSS:discardCallback(index)
    callbacks[index] = nil
end
