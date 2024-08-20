require "SSS_Utils_Shared"

-- Area and location functions

-- Check if a player is in a 3D area
function SSS:playerIsInArea3D(player, x1, y1, z1, x2, y2, z2)
    z1, z2 = SSS:sortAreaZ(z1, z2)
    for currentZ = z1, z2 do
        if SSS:playerIsInArea(player, x1, y1, x2, y2, currentZ) then
            return true
        end
    end
    return false
end

-- Check if a player is in a 2D area at a specific Z level
function SSS:playerIsInArea(player, x1, y1, x2, y2, z)
    if z == player:getZ() then
        return SSS:coordinateIsInAreaXY(math.floor(player:getX()), math.floor(player:getY()), x1, y1, x2, y2)
    end
    return false
end

-- Check if coordinates are within a specified 2D area
function SSS:coordinateIsInAreaXY(refX, refY, x1, y1, x2, y2)
    x1, y1, x2, y2 = SSS:sortAreaXY(x1, y1, x2, y2)
    return refX >= x1 and refX <= x2 and refY >= y1 and refY <= y2
end

-- Check if a texture name is within a specified area
function SSS:textureNameInAreaContains(name, x1, y1, x2, y2, z, fullMatch)
    x1, y1, x2, y2 = SSS:sortAreaXY(x1, y1, x2, y2)
    for currentX = x1, x2 do
        for currentY = y1, y2 do
            local square = getCell():getOrCreateGridSquare(currentX, currentY, z)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if object and object.getSprite and SSS:stringContains(object:getTextureName() or "", name, fullMatch) then
                        return true, object
                    end
                end
            end
        end
    end
    return false, nil
end

-- Sort Z coordinates to ensure z1 is less than or equal to z2
function SSS:sortAreaZ(z1, z2)
    if z2 < z1 then
        z1, z2 = z2, z1
    end
    return z1, z2
end

-- Sort X and Y coordinates to ensure x1 <= x2 and y1 <= y2
function SSS:sortAreaXY(x1, y1, x2, y2)
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    return x1, y1, x2, y2
end

-- Safehouse functions

-- Get the safehouse associated with a square
function SSS:getSafehouseToSquare(square)
    return SafeHouse.getSafeHouse(square)
end

-- Check if a square is within a safehouse
function SSS:squareIsInSafehouse(square)
    return SSS:getSafehouseToSquare(square) ~= nil
end
