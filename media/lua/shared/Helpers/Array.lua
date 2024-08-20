require "SSS_Utils_Shared"

-- Check if a value is in an array
function SSS:valueIsInArray(array, value, returnIndex)
    for i, aValue in ipairs(array) do
        if aValue == value then
            return returnIndex and i or true
        end
    end
    return false
end

-- Sort an array by value or by the first letter of each value
function SSS:sortArrayByValue(array, byFirstLetter)
    table.sort(array, function(a, b)
        if byFirstLetter then
            return SSS:getFirstLetter(a) < SSS:getFirstLetter(b)
        else
            return a < b
        end
    end)
    return array
end

-- Sort an array by its keys
function SSS:sortArrayByKey(array)
    local keys = {}
    for key in pairs(array) do
        table.insert(keys, key)
    end
    table.sort(keys)

    local result = {}
    for _, key in ipairs(keys) do
        result[key] = array[key]
    end
    return result
end

-- Split each item in an array by a separator
function SSS:splitEachArrayItemBySeparator(array, splitStr)
    for i, item in ipairs(array) do
        array[i] = SSS:splitString(item, splitStr)
    end
    return array
end

-- Count the number of elements in an array
function SSS:countArrayElements(array)
    local count = 0
    for _ in pairs(array) do
        count = count + 1
    end
    return count
end

-- Concatenate two arrays
function SSS:concatArrays(array1, array2)
    if not array2 then return array1 end
    for _, item in ipairs(array2) do
        table.insert(array1, item)
    end
    return array1
end

-- Merge two arrays
function SSS:mergeArrays(array1, array2)
    if not array2 then return array1 end
    for key, value in pairs(array2) do
        array1[key] = value
    end
    return array1
end

-- Reverse an array
function SSS:reverseArray(array)
    local size = #array
    for i = size - 1, 1, -1 do
        array[size] = table.remove(array, i)
    end
    return array
end

-- Copy an array
function SSS:copyArray(array)
    local copy = {}
    for _, item in ipairs(array) do
        table.insert(copy, item)
    end
    return copy
end

-- Clear an array
function SSS:clearArray(array)
    for key in pairs(array) do
        array[key] = nil
    end
    return array
end

-- Apply a function to each item in an array
function SSS:each(array, fn)
    for _, item in ipairs(array) do
        fn(item)
    end
end

-- Apply a function to each item in a collection
function SSS:eachInCollection(collection, itemFn)
    local count = 0
    if collection then
        for i = collection:size() - 1, 0, -1 do
            local item = collection:get(i)
            if item then
                itemFn(item, count)
                count = count + 1
            end
        end
    end
    return collection, count
end

-- Insert a value into an array if it's not already present
function SSS:insertIfNotInArray(array, value)
    if not SSS:valueIsInArray(array, value) then
        table.insert(array, value)
    end
    return array
end

-- Remove a value from an array
function SSS:removeFromArray(array, searchItem)
    local newArray = {}
    for _, item in ipairs(array) do
        if item ~= searchItem then
            table.insert(newArray, item)
        end
    end
    return newArray
end

-- Get a random item from an array, excluding a specified value
function SSS:getRandomItemFromArrayExcept(array, notYou)
    array = SSS:removeFromArray(array, notYou)
    return array[ZombRandBetween(1, #array + 1)]
end
