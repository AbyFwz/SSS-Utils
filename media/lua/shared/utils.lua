-- SSS = {}

-- -- Function to check if the object is a valid door or window
-- function SSS:checkValidObject(object)
--     return instanceof(object, "IsoDoor") or
--            (instanceof(object, "IsoThumpable") and object:isDoor()) or
--            instanceof(object, "IsoWindow")
-- end

-- -- Function to get the door key ID
-- function SSS:getDoorKeyID(door)
--     if instanceof(door, "IsoDoor") then
--         return door:checkKeyId()
--     elseif instanceof(door, "IsoThumpable") then
--         return door:getKeyId()
--     end
--     return nil
-- end

-- -- Function to generate a unique key ID
-- function SSS:generateKeyID()
--     return ZombRand(1000000, 9999999) -- Generates a random number between 1000000 and 9999999
-- end

-- -- Function to assign a key ID to a gate
-- function SSS:assignKeyIDToGate(object)
--     if object then
--         local keyID = SSS:generateKeyID()
--         object:setKeyId(keyID)
--         return keyID
--     end
--     return nil
-- end

-- -- Function to get square position as an array
-- function SSS:getSquarePosArray(square)
--     return { square:getX(), square:getY(), square:getZ() }
-- end

-- -- Function to add a delay
-- function SSS:delayAction(delayAmount, timeUnit, fn)
--     local targetTime

--     if timeUnit == "seconds" then
--         targetTime = SSS:getTimestamp() + (delayAmount * 1000)
--     elseif timeUnit == "minutes" then
--         targetTime = SSS:getTimestamp() + (delayAmount * 60000)
--     elseif timeUnit == "hours" then
--         targetTime = SSS:getTimestamp() + (delayAmount * 3600000)
--     else
--         error("Invalid time unit. Use 'seconds', 'minutes', or 'hours'.")
--     end

--     local function checkTime()
--         if SSS:getTimestamp() >= targetTime then
--             Events.OnTick.Remove(checkTime)
--             fn()
--         end
--     end

--     Events.OnTick.Add(checkTime)
-- end
