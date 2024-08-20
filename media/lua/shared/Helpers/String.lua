require "SSS_Utils_Shared"

-- Get substring from the last occurrence of a character
function SSS:getStringFromLastOccurrenceOfChar(str, chr)
    str = KahluaUtil.rawTostring2(str)
    if chr then
        return str:sub(1 - (str:reverse()):find("%" .. chr))
    end
    return nil
end

-- Split a string by a separator and optionally convert fragments
function SSS:splitString(srcString, separator, convertTo)
    local fragments = {}
    for fragment in srcString:gmatch("([^" .. separator .. "]+)") do
        if convertTo == "number" then
            fragment = tonumber(fragment)
        end
        table.insert(fragments, fragment)
    end
    return fragments
end

-- Split a coordinates string into a table of numbers
function SSS:splitCoordsString(coordsStr, separator)
    local coords = SSS:splitString(coordsStr, separator or ";")
    return {
        tonumber(coords[1]),
        tonumber(coords[2]),
        tonumber(coords[3])
    }
end

-- Remove non-alphanumeric characters from a string
function SSS:removeNonANLetters(srcString)
    return srcString:gsub("%W", "")
end

-- Get the first word from a string and return the rest of the string
function SSS:getFirstWord(srcString)
    local words = SSS:splitString(srcString, " ")
    return table.remove(words, 1), table.concat(words, " ")
end

-- Pad a string to the left or right
function SSS:padString(left, src, length, padChar)
    src = tostring(src)
    local strlen = #src
    padChar = padChar or " "

    if strlen < length then
        local padLength = length - strlen
        local pad = padChar:rep(padLength)
        src = left and pad .. src or src .. pad
    end

    return src
end

-- Pad a string to the left
function SSS:padLeft(src, length, padChar)
    return SSS:padString(true, src, length, padChar)
end

-- Pad a string to the right
function SSS:padRight(src, length, padChar)
    return SSS:padString(false, src, length, padChar)
end

-- Get the first letter of a string
function SSS:getFirstLetter(srcString)
    local firstLetter = srcString:match("%a") or srcString:match("[%z\1-\127\194-\244][\128-\191]*") or "?"
    return firstLetter
end

-- Trim whitespace from a string
function SSS:trimString(srcString)
    return string.trim(srcString)
end

-- Convert the first character of a string to uppercase
function SSS:ucFirst(srcString)
    return (srcString:gsub("^%l", string.upper))
end

-- Convert the first character of a string to lowercase
function SSS:lcFirst(srcString)
    return (srcString:gsub("^%l", string.lower))
end

-- Convert a string to lowercase
function SSS:stringToLower(srcString)
    return srcString:lower()
end

-- Get the first match of a pattern in a string
function SSS:getFirstMatch(srcString, pattern)
    return srcString:match(pattern)
end

-- Check if a string contains another string
function SSS:stringContains(srcString, needle, fullMatch)
    if fullMatch then
        return srcString == needle
    else
        return srcString:find(needle, 1, true) ~= nil
    end
end

-- Replace timestamps in a string with local time
function SSS:replaceTimestampWithLocalTime(srcString)
    for _, tsExp in ipairs(SSS["findTimestampExp"]) do
        for timestamp in srcString:gmatch(tsExp) do
            srcString = srcString:gsub(timestamp, "[" .. SSS:timestampToLocalTime(timestamp) .. "]")
        end
    end
    return srcString
end

-- Translate a string if needed
function SSS:translateIfNeeded(srcString)
    if srcString then
        srcString = tostring(srcString)
        for translation in srcString:gmatch(SSS["findTranslationExp"]) do
            srcString = srcString:gsub(SSS:escapeString(translation), getText(translation))
        end
        srcString = SSS:replaceTimestampWithLocalTime(srcString)
        srcString = SSS:trimString(srcString)
    end
    return srcString
end

-- Convert a timestamp to local time
function SSS:timestampToLocalTime(timestamp)
    local cal = Calendar.getInstance()
    cal:setTimeInMillis(tonumber(timestamp))
    return tostring(cal:getTime())
end

-- Convert a timestamp to local clock time
function SSS:timestampToLocalClock(timestamp)
    local cal = Calendar.getInstance()
    cal:setTimeInMillis(tonumber(timestamp))
    return string.format("%02d:%02d", cal:get(Calendar.HOUR_OF_DAY), cal:get(Calendar.MINUTE))
end

-- Remove quotes from a string
function SSS:removeQuotes(srcString)
    return srcString:gsub('"', "")
end

-- Check if a string contains any of the strings in an array
function SSS:stringContainsMultiple(srcString, containsArr)
    for _, searchStr in ipairs(containsArr) do
        if srcString:find(searchStr) then
            return true
        end
    end
    return false
end

-- Escape special characters in a string
function SSS:escapeString(srcString)
    return srcString:gsub("([^%w])", "%%%1")
end

-- Create a case-insensitive text pattern
function SSS:createCITextPattern(text)
    local newText = ""
    for char in SSS:escapeString(text or ""):gmatch(".") do
        if char:match("[%u%l]") then
            newText = newText .. "[" .. char:lower() .. char:upper() .. "]"
        else
            newText = newText .. char
        end
    end
    return newText
end
