SSS = SSS or {}
SSS.Vehicle = SSS.Vehicle or {}

-- Uninstall a part from a vehicle
function SSS.Vehicle:uninstallPart(vehicle, partSlot, silent)
    local part = vehicle:getPartById(partSlot)

    if part and part:getInventoryItem() then
        part:setInventoryItem(nil)
        local uninstallTable = part:getTable("uninstall")

        if uninstallTable and uninstallTable.complete then
            VehicleUtils.callLua(uninstallTable.complete, vehicle, part, part:getInventoryItem())
        end

        SSS:log(" - uninstalling part in slot " .. tostring(partSlot))

        if not silent then
            vehicle:transmitPartItem(part)
        end
    else
        SSS:log(" - unable to uninstall part in slot " .. tostring(partSlot))
    end
end

-- Install a part into a vehicle
function SSS.Vehicle:installPart(vehicle, partSlot, itemId, silent)
    local item = InventoryItemFactory.CreateItem(itemId)
    local part = vehicle:getPartById(partSlot)

    if part and item then
        part:setInventoryItem(item)
        local installTable = part:getTable("install")

        if installTable and installTable.complete then
            VehicleUtils.callLua(installTable.complete, vehicle, part)
        end

        SSS:log(" - installing part " .. tostring(itemId) .. " in slot " .. tostring(partSlot))

        if not silent then
            vehicle:transmitPartItem(part)
        end
    else
        SSS:log(" - unable to install part " .. tostring(itemId) .. " in slot " .. tostring(partSlot))
    end
end

-- Check if a part is installed
function SSS.Vehicle:partIsInstalled(part)
    return not (part:getItemType() and not part:getItemType():isEmpty() and not part:getInventoryItem())
end
