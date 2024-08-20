if isServer() then
    return
end

SSS = SSS or {}
SSS.SquareEvents = SSS.SquareEvents or {}

function SSS.SquareEvents:processHooks(square)
    if not square then return end

    local objects = square:getObjects()
    local hooks = SSS.Hooks:get("eachObjectOnSquareLoad")

    SSS:eachInCollection(objects, function(object)
        local modData = object and object:getModData() or {}
        for _, hookFn in ipairs(hooks) do
            hookFn(object, square, modData)
        end
    end)
end

function SSS.SquareEvents:executeLoadSquareHooks(square)
    if SSS.Hooks:exist("eachObjectOnSquareLoad") then
        self:processHooks(square)
    end
end

Events.LoadGridsquare.Add(function(square)
    local bufferTime = SSS:getSandboxVar("BufferSquareLoadHandlers")

    local processHooks = function()
        SSS.SquareEvents:processHooks(square)
    end

    if bufferTime > 0 then
        SSS:waitSecondsUntil(bufferTime, processHooks)
    else
        processHooks()
    end
end)
