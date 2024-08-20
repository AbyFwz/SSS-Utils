require "SSS_Utils_Server"

SSS = SSS or {}
SSS.Commands = SSS.Commands or {}

-- Helper functions

-- Send a line to chat
function SSS.Commands:sendLineToChat(playerObj, messageArray)
    sendServerCommand(playerObj, "SSS", "addLineToChat", { message = messageArray })
end

-- Send a success message
function SSS.Commands:sendSuccessMessage(playerObj, messageArray)
    sendServerCommand(playerObj, "SSS", "addSuccessMessage", { message = messageArray })
end

-- Send an error message
function SSS.Commands:sendErrorMessage(playerObj, messageArray)
    sendServerCommand(playerObj, "SSS", "addErrorMessage", { message = messageArray })
end

-- Send a supporter message
function SSS.Commands:sendSupporterMessage(playerObj, messageArray)
    sendServerCommand(playerObj, "SSS", "addSupporterMessage", { message = messageArray })
end

-- Send a halo message
function SSS.Commands:sendHaloMessage(playerObj, msgType, messageArray)
    SSS:sendMessageBatch(playerObj, { { mType = msgType or "default", message = messageArray } }, "halo")
end

-- Send a batch of messages
function SSS.Commands:sendMessageBatch(playerObj, messageBatch, target, args)
    sendServerCommand(playerObj, "SSS", "processMessageBatch", SSS:mergeArrays({ messages = messageBatch, target = target }, args))
end
