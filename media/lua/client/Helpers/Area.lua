require "SSS_Utils_Client"

-- Highlight a single object
function SSS:highlightObject(object)
    if object then
        object:setHighlighted(true)
        object:setHighlightColor(SSS.speechR, SSS.speechG, SSS.speechB, 1)
    end
end

-- Highlight all objects in a 2D area
function SSS:highlightArea(x1, y1, x2, y2, z, full)
    SSS:eachObjectInArea(x1, y1, x2, y2, z, function(object)
        SSS:highlightObject(object)
    end, full)
end

-- Highlight all objects in a 3D area
function SSS:highlightArea3D(x1, y1, z1, x2, y2, z2, full)
    z1, z2 = SSS:sortAreaZ(z1, z2)
    for currentZ = z1, z2 do
        SSS:highlightArea(x1, y1, x2, y2, currentZ, full)
    end
end

-- Iterate over all objects in a 2D area
function SSS:eachObjectInArea(x1, y1, x2, y2, z, fn, full)
    x1, y1, x2, y2 = SSS:sortAreaXY(x1, y1, x2, y2)
    local cell = getCell()

    for currentX = x1, x2 do
        for currentY = y1, y2 do
            if full ~= false or not (currentX > x1 and currentX < x2 and currentY > y1 and currentY < y2) then
                local square = cell:getGridSquare(currentX, currentY, z)
                if square then
                    local objects = square:getObjects()
                    for i = 0, objects:size() - 1 do
                        local object = objects:get(i)
                        if fn(object, square, currentX, currentY, z) == true then
                            return true
                        end
                    end
                end
            end
        end
    end
end

-- Iterate over all objects in a 3D area
function SSS:eachObjectInArea3D(x1, y1, z1, x2, y2, z2, fn)
    z1, z2 = SSS:sortAreaZ(z1, z2)
    for currentZ = z1, z2 do
        SSS:eachObjectInArea(x1, y1, x2, y2, currentZ, fn)
    end
end

-- Iterate over all objects around the player within a certain distance
function SSS:eachObjectAroundPlayer(maxDistance, handler)
    local playerPos = SSS:getPlayerPosition(SSS:getPlayer(), true, true)
    SSS:eachObjectInArea(
        playerPos[1] - maxDistance, playerPos[2] - maxDistance,
        playerPos[1] + maxDistance, playerPos[2] + maxDistance,
        playerPos[3], handler
    )
end

-- Get the position of a square as an array
function SSS:getSquarePosArray(square)
    return { square:getX(), square:getY(), square:getZ() }
end
