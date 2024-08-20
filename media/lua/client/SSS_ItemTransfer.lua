SSS = SSS or {}
SSS.ItemTransfer = SSS.ItemTransfer or {}

function SSS.ItemTransfer:allowItemTransfer(item, srcContainer, destContainer, player)
    if SSS:playerIsAdmin(player) then
        return true
    end

    for _, hookFn in ipairs(SSS.Hooks:get("itemTransferAllowed")) do
        if hookFn(item, srcContainer, destContainer, player) == false then
            return false
        end
    end

    return true
end

function SSS.ItemTransfer:removeForbiddenFromItemList(items, destContainer, player)
    local wasChanged = false

    for i = #items, 1, -1 do
        if not SSS.ItemTransfer:allowItemTransfer(items[i], items[i]:getContainer(), destContainer, player) then
            table.remove(items, i)
            wasChanged = true
        end
    end

    return items, wasChanged
end
