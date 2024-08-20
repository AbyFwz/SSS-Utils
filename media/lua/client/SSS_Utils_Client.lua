-- Shortcuts
function SSS:onRespawn()
    SSS.currentPlayer = getPlayer()
end

function SSS:sendClientCommand(moduleName, handler, args)
    sendClientCommand(SSS:getPlayer(), moduleName or "SSS", handler, args or {})
end

function SSS:processServerTextMessage(args, mType, player, target)
    local message = args["message"]

    if type(message) == "table" then
        message = getText(message[1], SSS:translateIfNeeded(message[2]), SSS:translateIfNeeded(message[3]), SSS:translateIfNeeded(message[4]), SSS:translateIfNeeded(message[5]))
    else
        message = SSS:translateIfNeeded(message)
    end

    args["message"] = message


    if mType == "addSuccessMessage" then
        SSS:saySuccess(message)
    elseif mType == "addErrorMessage" then
        SSS:sayError(message)
    else
        SSS:sayInColor(message, 255, 255, 255)
    end

    return args
end

-- Events
Events.OnGameStart.Add(function()
    SSS:onRespawn()
end)

Events.OnCreatePlayer.Add(function()
    SSS:onRespawn()
end)

Events.OnServerCommand.Add(function(moduleName, command, args)
    if moduleName == "SSS" then
        if command == "addSuccessMessage" and args["message"] then
            SSS:processServerTextMessage(args, command, player)
        end

        if command == "addErrorMessage" and args["message"] then
            SSS:processServerTextMessage(args, command, player)
        end

        if command == "addLineToChat" and args["message"] then
            SSS:processServerTextMessage(args, command, player)
        end

        if command == "processMessageBatch" and args["messages"] then
            local isBook = args["target"] == "document" and args["docTitle"]

            if isBook then
                SSS:beginBook()
            end

            for i, message in ipairs(args["messages"]) do
                SSS:processServerTextMessage(message, "add" .. SSS:ucFirst(message["mType"] or "default") .. "Message", player,
                    args["target"] == "document" and not args["docTitle"] and nil or args["target"]
                )
            end

            if isBook then
                SSS:writeBook(getText(args["docTitle"], SSS:getIngameTimeStr()), args["linesPerPage"] or nil, args["playerSay"] or nil)
            end
        end

        if command == "writeBook" and args["lines"] then
            SSS:dumpListToBook(args["name"] or "???", args["lines"], args["linesPerPage"])
        end

        if command == "executeCallback" and args["callback"] then
            SSS:executeCallback(args["callback"])
        end

        if command == "discardCallback" and args["callback"] then
            SSS:discardCallback(args["callback"])
        end

        if command == "setPlayerList" and args["list"] then
            SSS["onlinePlayersCache"] = args["list"]
        end
    end
end)

-- Event stuff
function SSS:doAfterLogin(handler)
    if SSS:chatIsEnabled() then
        Events.OnGameStart.Add(function()
            SSS.Hooks:add("SSSChatWelcome", function(chat)
                handler()
            end)
        end)
    else
        Events.OnCreatePlayer.Add(function()
            SSS:waitSecondsUntil(5, function()
                handler()
            end)
        end)
    end
end
