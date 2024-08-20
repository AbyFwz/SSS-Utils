SSS = SSS or {}
SSS.Selection = SSS.Selection or {}

-- Manage selection
function SSS.Selection:setSquare(index, square)
    if square then
        SSS.Selection["square" .. index] = square
    end
end

function SSS.Selection:reset()
    SSS.Selection.square1 = nil
    SSS.Selection.square2 = nil
    SSS.Selection:stop()
end

function SSS.Selection:getHighlightPoints(square1, square2)
    local p1 = square1 or SSS.Selection.square1
    local p2 = square2 or SSS.Selection.square2

    if p1 or p2 then
        p1 = p1 or p2
        p2 = p2 or p1
    end

    return SSS:getSquarePosArray(p1), SSS:getSquarePosArray(p2)
end

-- Highlight
function SSS.Selection:highlight(square1, square2)
    local p1, p2 = SSS.Selection:getHighlightPoints(square1, square2)

    if p1 or p2 then
        SSS.Selection:stop()
        SSS.Selection.highlightTask = function()
            SSS:highlightArea3D(p1[1], p1[2], p1[3], p2[1], p2[2], p2[3], false)
        end
        Events.OnRenderTick.Add(SSS.Selection.highlightTask)
    end
end

function SSS.Selection:stop()
    if SSS.Selection.highlightTask then
        Events.OnRenderTick.Remove(SSS.Selection.highlightTask)
    end
end

-- Processing
function SSS.Selection:eachObjectInSelection(fn, allLevels)
    local p1, p2 = SSS.Selection:getHighlightPoints()

    if p1 or p2 then
        SSS:eachObjectInArea3D(
            p1[1], p1[2], not allLevels and p1[3] or 0,
            p2[1], p2[2], not allLevels and p2[3] or 7,
            fn
        )
    end
end
