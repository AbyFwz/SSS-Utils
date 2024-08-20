-- require "utils"
-- ---
-- --- Event handler for OnFillWorldObjectContextMenu
-- --- @param player int ID of the player who did the right click
-- --- @param context ISContextMenu The current context menu object
-- --- @param worldobjects table Global objects found on the clicked point
-- --- @param test boolean Whether this call is a fetch only call for controller support
-- ---

-- local function removeDuplicates(wObjects)
--     local newObjects = {}

--     for i, oldObj in ipairs(wObjects) do
--         local isInList = false
--         for j, newObj in ipairs(newObjects) do
--             if newObj == oldObj then
--                 isInList = true
--                 break
--             end
--         end
--         if not isInList then
--             table.insert(newObjects, oldObj)
--         end
--     end
--     return newObjects
-- end

-- local function getAllDoorObjects(object)
--     local doubleDoorObjects = buildUtil.getDoubleDoorObjects(object)
--     local garageDoorObjects = buildUtil.getGarageDoorObjects(object)
--     local doorObjects = {}

--     for i = 1, #doubleDoorObjects
--     do
--         table.insert(doorObjects, doubleDoorObjects[i])
--     end

--     for i = 1, #garageDoorObjects
--     do
--         table.insert(doorObjects, garageDoorObjects[i])
--     end

--     if #doorObjects == 0
--     then
--         table.insert(doorObjects, object)
--     end

--     return doorObjects, #doubleDoorObjects > 0, #garageDoorObjects > 0
-- end

-- local function makeObjectsIndestructible(object, state)
--     if object and instanceof(object, "IsoObject") or instanceof(object, "IsoDoor") or instanceof(object, "IsoThumpable") then
--         if state then
--             if instanceof(object, "IsoThumpable") then
--                 object:setIsDismantable(false)
--                 object:setIsThumpable(false)
--                 object:setIsLocked(true)
--                 object:setHoppable(false)
--             else
--                 object:setLocked(true)
--                 object:setHealth(1000000)
--             end
--             object:setLockedByKey(true)

--             print("Object has been made indestructible.")
--         elseif not state then
--             if instanceof(object, "IsoThumpable") then
--                 object:setIsDismantable(true)
--                 object:setIsThumpable(true)
--                 object:setIsLocked(false)
--                 object:setHoppable(true)

--             else
--                 object:setLocked(false)
--                 object:setHealth(object:getMaxHealth())
--             end
--             object:setLockedByKey(false)

--             print("Object has been made destructible.")
--         end
--     else
--         print("The object is not a valid IsoObject.")
--     end
-- end

-- local function compileDoorBackupData(object)
--     local backup = {
--         spriteName = {},
--         positions = {},
--     }

--     for i, doorSegment in ipairs(object)
--     do
--         table.insert(backup.spriteName, doorSegment:getSprite():getName())
--         table.insert(backup.positions, SSS:getSquarePosArray(doorSegment:getSquare()))
--     end

--     return backup
-- end

-- local function copyModData(sourceObject, targetObject, state)
--     if not sourceObject or not targetObject then return end

--     for key, value in pairs(sourceObject:getModData()) do
--         targetObject:getModData()[key] = value
--     end

--     targetObject:transmitModData()
-- end


-- local function toggleSecurityWall(object, state)
--     local sprite1 = "location_shop_mall_01_18"
--     local sprite2 = "location_shop_mall_01_19"

--     if state then -- If wanna lock
--         local targetSquare = object:getSquare()
--         local spriteName = object:getNorth() and sprite2 or sprite1
--         local props = ISMoveableSpriteProps.new(IsoObject.new(targetSquare, spriteName):getSprite())

--         props["rawWeight"] = 10

--         props:placeMoveableInternal(targetSquare, InventoryItemFactory.CreateItem("Base.Plank"), spriteName)

--         local objects = targetSquare:getObjects()

--         for i = 0, objects:size() - 1 do
--             local target = objects:get(i);

--             if target and target:getSprite() and target:getSprite():getName() == spriteName then
--                 copyModData(object, target, state);
--             end
--         end
--     else -- If wanna unlock
--         local square = object:getSquare()
--         local spriteName = object:getNorth() and sprite2 or sprite1
--         local objects = square:getObjects()

--         if objects then
--             for i = 0, objects:size()-1 do
--                 local target = objects:get(i)
--                 if target and target:getSprite() and target:getSprite():getName() == spriteName then
--                     print("Object Removed: ", target:getSprite():getName(), " on: ", target:getX(), ",", target:getY(), ",", target:getZ(), " in ", i, " loop")
--                     square:transmitRemoveItemFromSquare(target)
--                     target:removeFromSquare()
--                 end
--             end
--         else
--             print("Not a valid object")
--         end
--     end
-- end

-- local function toggleLocked(object, state, playerObj)
--     local doorObjects = getAllDoorObjects(object)
--     for i, doorSegment in ipairs(doorObjects) do
--         if doorSegment:IsOpen() then
--             playerObj:Say("IGUI_SSS_Door_Open")
--             return
--         end
--         local modData = doorSegment:getModData()

--         modData["SSS:lockActive"] = state
--         modData["SSS:doorCount"] = modData["SSS:doorCount"] or #doorObjects
--         modData["SSS:doorIndex"] = modData["SSS:doorIndex"] or i
--         modData["SSS:backupData"] = modData["SSS:backupData"] or {}

--         if not modData["SSS:backupData"] or #modData["SSS:backupData"] < modData["SSS:doorCount"] then
--             modData["SSS:backupData"] = compileDoorBackupData(doorObjects)
--         end

--         makeObjectsIndestructible(doorSegment, state)
--         toggleSecurityWall(doorSegment, state)
--         SSS:delayAction(3, "seconds", toggleSecurityWall(doorSegment, state))
--     end
-- end

-- local function addModData(object, player)
--     local playerObj = player
--     local doorObjects, isDoubleDoor, isGarageDoor = getAllDoorObjects(object)
--     local timestamp = getTimestamp()

--     for i, doorSegment in ipairs(doorObjects) do
--         if doorSegment:IsOpen() then
--             playerObj:Say("IGUI_SSS_Door_Open")
--             return
--         end
--         local modData = doorSegment:getModData()

--         modData["SSS:lockInstalled"] = false
--         modData["SSS:lockInstalledBy"] = playerObj:getUsername()
--         modData["SSS:lockInstallDate"] = timestamp
--         modData["SSS:lockActive"] = true
--         modData["SSS:lockPassword"] = "0"
--         modData["SSS:sensorInstalled"] = false
--         modData["SSS:sensorInstalledBy"] = playerObj:getUsername()
--         modData["SSS:sensorIinstallDate"] = timestamp
--         modData["SSS:sensorType"] = "Test Purpose"

--         if not modData["SSS:initialSprite"] and doorSegment:getSprite()
--         then
--             modData["SSS:initialSprite"] = doorSegment:getSprite():getName()
--         end

--         modData["SSS:doorCount"] = #doorObjects
--         modData["SSS:doorIndex"] = i
--         modData["SSS:backupData"] = modData["SSS:backupData"] or {}

--         if not modData["SSS:backupData"] or #modData["SSS:backupData"] < modData["SSS:doorCount"] then
--             modData["SSS:backupData"] = compileDoorBackupData(doorObjects)
--         end

--         makeObjectsIndestructible(doorSegment, true)
--         toggleLocked(doorSegment, true)
--     end
-- end

-- local function clearModData(object, player)
--     local playerObj = player
--     local doorObjects, isDoubleDoor, isGarageDoor = getAllDoorObjects(object)

--     for i, doorSegment in ipairs(doorObjects) do
--         local modData = doorSegment:getModData()

--         for key, value in pairs(modData) do
--             if string.find(key, "SSS") then
--                 modData[key] = nil
--                 -- print("Success clear modData on: ", doorSegment:getSprite():getName())
--             end
--         end

--         makeObjectsIndestructible(doorSegment, false)
--         toggleLocked(doorSegment, false)
--     end
-- end

-- local function GenerateContextMenu(player, context, worldObjects, test)
--     local playerObj = getSpecificPlayer(player)
--     worldObjects = removeDuplicates(worldObjects)
--     local state

--     for _, object in ipairs(worldObjects) do
--         ---@type IsoObject
--         if SSS:checkValidObject(object) then
--             local doorObjects, isDoubleDoor, isGarageDoor = getAllDoorObjects(object)
--             local objModData = object:getModData();
--             local newKeyID = SSS:generateKeyID()

--             for i, doorSegment in ipairs(doorObjects) do
--                 local keyID = SSS:getDoorKeyID(doorSegment)
--                 if not keyID or keyID == -1 then
--                     -- keyID = assignKeyIDToGate(object)
--                     doorSegment:setKeyId(newKeyID)
--                     -- print("New key ID: ", newKeyID )
--                 end
--             end

--             if objModData and objModData["SSS:lockActive"] then
--                 state = false
--             else
--                 state = true
--             end

--             context:addOption("SSS: Add Mod Data", object, addModData, playerObj)
--             context:addOption("SSS: Clear Mod Data", object, clearModData, playerObj)
--             context:addOption("SSS: Toggle Lock", object, toggleLocked, state, playerObj)
--         end
--     end
-- end

-- Events.OnFillWorldObjectContextMenu.Add(GenerateContextMenu)