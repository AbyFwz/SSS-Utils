require "ISUI/ISInventoryPane"
require "TimedActions/ISGrabItemAction"
require "TimedActions/ISInventoryTransferAction"

local function onGameStart()
    -- Override transferItemsByWeight function
    local originalTransferItemsByWeight = ISInventoryPane.transferItemsByWeight
    ISInventoryPane.transferItemsByWeight = function(self, items, container)
        local filteredItems, wasChanged = SSS.ItemTransfer:removeForbiddenFromItemList(items, container, SSS:getPlayer())
        return originalTransferItemsByWeight(self, filteredItems, container)
    end

    -- Override isValid function for ISGrabItemAction
    local originalGrabItemIsValid = ISGrabItemAction.isValid
    ISGrabItemAction.isValid = function(self)
        local item = self.item:getItem()
        local container = item:getContainer()
        local inventory = self.character:getInventory()
        if not SSS.ItemTransfer:allowItemTransfer(item, container, inventory, self.character) then
            self:stop()
            return false
        end
        return originalGrabItemIsValid(self)
    end

    -- Override isValid function for ISInventoryTransferAction
    local originalTransferItemIsValid = ISInventoryTransferAction.isValid
    ISInventoryTransferAction.isValid = function(self)
        if not SSS.ItemTransfer:allowItemTransfer(self.item, self.srcContainer, self.destContainer, self.character) then
            self:stop()
            return false
        end
        return originalTransferItemIsValid(self)
    end
end

Events.OnGameStart.Add(onGameStart)
