SSS = SSS or {}
SSS.Commands = SSS.Commands or {}

SSS = SSS or {}
SSS.Commands = SSS.Commands or {}

-- Set item mod data
function SSS.Commands.setItemModData(playerObj, args)
    if args and args.item and args.key and args.value then
        args.item:getModData()[args.key] = args.value
    end
end

-- Log to file
function SSS.Commands.logToFile(playerObj, args)
    if args and args.file and args.content then
        SSS.Commands:addLinesToLogFile(args.file, args.content, args.useTimestamp)
    end
end

-- Log exploit
function SSS.Commands.logExploit(playerObj, args)
    SSS:appendUniqueLineToFile("SSS_detected_exploits.log", string.format("%s [%s] %s",
        tostring(args.steamId) or "unknown steam id", args.username or "unknown username", args.reason or "unknown reason"))
end

-- Helpers

-- Add lines to log file
function SSS.Commands:addLinesToLogFile(fileName, content, useTimestamp)
    local timeStr = tostring(useTimestamp ~= true and Calendar.getInstance():getTime() or SSS:getTimestamp())

    for _, line in ipairs(SSS:tableIfNotTable(content)) do
        SSS:appendLineToFile(fileName, "[" .. timeStr .. "] " .. line)
    end
end

-- Events

Events.OnClientCommand.Add(function(moduleName, command, playerObj, args)
    if moduleName == "SSS" and SSS.Commands[command] then
        SSS.Commands[command](playerObj, args);
    end
end)
