require "SSS_Utils_Client"

-- Flatten inventory stack items into a single list
function SSS:flattenInventoryStackItems(clickedItems)
    if clickedItems[1].items then
        local items = {}
        for _, stack in ipairs(clickedItems) do
            for j = 2, #stack.items do
                table.insert(items, stack.items[j])
            end
        end
        return items
    else
        return clickedItems[1]
    end
end

-- Apply a function to each item in the inventory stack
function SSS:eachInventoryStackItem(clickedItems, fn)
    if clickedItems[1].items then
        for _, stack in ipairs(clickedItems) do
            for j = 2, #stack.items do
                fn(stack.items[j])
            end
        end
    else
        for _, item in ipairs(clickedItems) do
            fn(item)
        end
    end
end

-- Set mod data for an item
function SSS:setItemModData(item, key, value)
    item:getModData()[key] = value
end

-- Get a random color bulb type
function SSS:getRandomColorBulbType()
    local colors = { "Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Purple", "Pink" }
    return "Base.LightBulb" .. colors[ZombRand(1, #colors)]
end

-- Get the texture of an item by its ID
function SSS:getIconToItemId(itemId)
    local example = InventoryItemFactory.CreateItem(itemId)
    if example and example:getTexture() then
        return example:getTexture()
    end
end
