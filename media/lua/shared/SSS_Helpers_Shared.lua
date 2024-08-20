require "SSS_Utils_Shared"

SSS = SSS or {}

-- Checks

function SSS:isFunction(var)
    return type(var) == "function"
end

function SSS:tableIfNotTable(var)
    if type(var) ~= "table" then
        return { var }
    end
    return var
end

function SSS:stringIsNumber(var)
    return tostring(var) == tostring(tonumber(var))
end

-- Debug and logging

function SSS:logToServerFile(fullFilePath, content)
    SSS:sendClientCommand("SSS", "logToFile", {
        file = fullFilePath,
        content = content,
    })
end

function SSS:logExploit(steamId, username, reason)
    steamId = steamId or getCurrentUserSteamID()

    SSS:sendClientCommand("SSS", "logExploit", {
        steamId = steamId,
        username = username,
        reason = reason,
    })

    local text = string.format("%s [%s] %s",
        steamId or "unknown steam id", username or "unknown username", reason or "unknown reason"
    )

    if ISLogSystem then
        ISLogSystem.sendLog(player, "SSS_Detected_Exploits", text)
    end
end

function SSS:printArray(array, toLog)
    for k, v in pairs(array) do
        local message = tostring(k) .. " = " .. tostring(v)
        if not toLog then
            print(message)
        else
            SSS:log(message)
        end
    end
end

function SSS:logArray(array, indent, path)
    indent = indent or ""
    path = path or ""

    for k, v in pairs(array) do
        local message
        if type(v) == "table" then
            message = string.format("%s - (%s) %s%s:", indent, type(v), path, tostring(k))
            SSS:log(message)
            SSS:logArray(v, "   " .. indent, string.format("%s%s.", path, k))
        elseif type(v) == "function" then
            message = string.format("%s - (%s) %s%s", indent, type(v), path, tostring(k))
            SSS:log(message)
        else
            message = string.format("%s - (%s) %s%s = %s", indent, type(v), path, tostring(k), tostring(v))
            SSS:log(message)
        end
    end
end

function SSS:log(message, isMigration)
    local player = SSS.getPlayer and SSS:getPlayer()

    if getDebug() or isMigration or (player and player:getDisplayName() == "bikinihorst") then
        local logFile = not isMigration and SSS.Files.debugLog or SSS.Files.migrationLog
        SSS:appendLineToFile(logFile, message)
    end
end

function SSS:logMigration(message)
    SSS:log(message, true)
end

function SSS:logStackTraceOrigin()
    local coroutine = getCurrentCoroutine()
    local origin = KahluaUtil.rawTostring2(getCoroutineCallframeStack(coroutine, 0))

    SSS:log(" - Mod: " .. '"' .. tostring(string.match(origin, SSS:escapeString(" | MOD: ") .. "(.+)$")) .. '"')
    SSS:log(" - File: " .. tostring(string.match(origin, SSS:escapeString("-- file: ") .. "(.+)" .. SSS:escapeString(" line #"))) .. " # " .. tostring(string.match(origin, SSS:escapeString("line # ") .. "(.+)" .. SSS:escapeString(" |"))))
end

function SSS:getSCPrefix()
    return "[" .. (isServer() and "S" or "C") .. "] "
end

-- Init

if getDebug() then
    SSS:saveItemListInFile(SSS.Files.debugLog, {
        "#####################################################################",
        "debug session started: " .. tostring(Calendar.getInstance():getTime()),
        "#####################################################################",
        ""
    })
end
