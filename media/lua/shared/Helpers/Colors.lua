require "SSS_Utils_Shared"

-- Transform an RGB color to a tag
function SSS:transformRGBColorToTag(color)
    return SSS:transformRGBTableToRGBTag(SSS:transformColor(color))
end

-- Transform an RGB table to an RGB tag
function SSS:transformRGBTableToRGBTag(rgbTable)
    return string.format("<RGB:%d,%d,%d>", rgbTable.r, rgbTable.g, rgbTable.b)
end

-- Transform color values to a normalized RGB table
function SSS:transformColor(r, g, b, returnRGB)
    local divisor = returnRGB and 1 or 255

    if type(r) == "table" then
        for letter, value in pairs(r) do
            r[letter] = value / divisor
        end

        if not r.r then
            r.r, r.g, r.b = r[1], r[2], r[3]
        end

        return r
    else
        return {
            r = r / divisor,
            g = g / divisor,
            b = b / divisor
        }
    end
end

-- Transform a rich text color string to an RGB table
function SSS:transformRichTextColorString(colorStr, returnRGB)
    local colors = SSS:splitString(colorStr:sub(2, -2), ",")
    return SSS:transformColor(colors[1], colors[2], colors[3], returnRGB)
end

-- Convert ColorInfo to an RGBA string
function SSS:colorInfoToRGBA(colorInfo)
    return string.format("%d,%d,%d,%d", colorInfo:getR(), colorInfo:getG(), colorInfo:getB(), colorInfo:getA())
end

-- Convert an RGBA string to ColorInfo
function SSS:rgbaStrToColorInfo(rgbaStr)
    local color = SSS:splitString(rgbaStr, ",")
    return ColorInfo.new(tonumber(color[1]), tonumber(color[2]), tonumber(color[3]), tonumber(color[4]))
end

-- Get the multiplayer text color as an RGB table
function SSS:playerMPColorToRGB()
    local mpColor = getCore():getMpTextColor()
    return {
        math.floor(mpColor:getR() * 255),
        math.floor(mpColor:getG() * 255),
        math.floor(mpColor:getB() * 255)
    }
end

-- Add a special color to the chat
function SSS:addSpecialColor(key, r, g, b)
    local color = { r = r, g = g, b = b }
    color.rgbStr = string.format("*%d,%d,%d*", r, g, b)
    color.rgbExp = SSS:escapeString(color.rgbStr)
    SSS.Chat.specialColors[key] = color
    return color
end

-- Get the RGB values of a special color
function SSS:getSpecialColorRGB(key)
    local color = SSS.Chat.specialColors[key]
    if color then
        return { color.r, color.g, color.b }
    else
        return { SSS.speechR * 255, SSS.speechG * 255, SSS.speechB * 255 }
    end
end

-- Check if a string contains any special color
function SSS:stringContainsASpecialColor(srcString)
    for key, _ in pairs(SSS.Chat.specialColors) do
        if SSS:stringContainsSpecialColor(srcString, key) then
            return key
        end
    end
    return false
end

-- Check if a string contains a specific special color
function SSS:stringContainsSpecialColor(srcString, key)
    local color = SSS.Chat.specialColors[key]
    return color and srcString:match(color.rgbExp) or false
end
