require "SSS_Utils_Shared"

-- Array string manipulation functions

-- Check if an item is in an array string
function SSS:itemIsInArrayString(list, item, separator)
    if list and item then
        local index = SSS:findItemIndexInArrayString(list, item, separator)
        return index > -1
    end
    return false
end

-- Add an item to an array string
function SSS:addItemToArrayString(str, item, separator)
    separator = separator or SSS.stringArrayDivider
    local fragments = SSS:splitArrayString(str, separator)
    table.insert(fragments, item)
    return SSS:mergeIntoArrayString(fragments, separator)
end

-- Remove an item from an array string
function SSS:removeItemFromArrayString(str, item, separator)
    local index, fragments = SSS:findItemIndexInArrayString(str, item, separator)
    if index > -1 then
        table.remove(fragments, index)
        return SSS:mergeIntoArrayString(fragments, separator)
    end
    return str
end

-- Remove an item from an array string by index
function SSS:removeIndexFromArrayString(str, index, separator)
    local fragments = SSS:splitArrayString(str, separator)
    table.remove(fragments, index)
    return SSS:mergeIntoArrayString(fragments, separator)
end

-- Find the index of an item in an array string
function SSS:findItemIndexInArrayString(str, item, separator)
    if str then
        separator = separator or SSS.stringArrayDivider
        local fragments = SSS:splitArrayString(str, separator)
        for i, fragment in ipairs(fragments) do
            if fragment == item then
                return i, fragments
            end
        end
        return -1, fragments
    end
    return -1, {}
end

-- Split an array string into a table of fragments
function SSS:splitArrayString(str, separator)
    local fragments = {}
    if str and str ~= "" then
        separator = separator or SSS.stringArrayDivider
        for fragment in str:gmatch("([^" .. separator .. "]+)") do
            table.insert(fragments, fragment)
        end
    end
    return fragments
end

-- Replace an item in an array string by index
function SSS:replaceItemInArrayString(str, index, newItem, separator)
    if index > -1 then
        separator = separator or SSS.stringArrayDivider
        local fragments = SSS:splitArrayString(str, separator)
        fragments[index] = newItem
        return SSS:mergeIntoArrayString(fragments, separator)
    end
    return str
end

-- Merge a table of fragments into an array string
function SSS:mergeIntoArrayString(fragments, separator)
    separator = separator or SSS.stringArrayDivider
    return table.concat(fragments, separator)
end
