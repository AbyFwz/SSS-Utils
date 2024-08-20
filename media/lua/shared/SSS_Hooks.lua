require "SSS_Base_Shared"

SSS = SSS or {}
SSS.Hooks = SSS.Hooks or {}

-- Context menus
local contextHooks = {
    "playerContext", "generatorContext", "doorContext", "SSSContext", "staffContainerContext"
}

-- Object and sprite protection
local protectionHooks = {
    "spriteIsProtected", "objectIsProtected", "spriteIsNotProtected", "objectIsNotProtected", "objectDestroyedWithSledge"
}

-- Chat related
local chatHooks = {"SSSChatWelcome"}

-- Vehicles
local vehicleHooks = {"onVehicleInit"}

-- Item transfer
local itemTransferHooks = {"itemTransferAllowed"}

-- Objects on squares
local squareHooks = {"eachObjectOnSquareLoad"}

-- Initialize hooks
for _, hookType in ipairs(contextHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

for _, hookType in ipairs(protectionHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

for _, hookType in ipairs(chatHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

for _, hookType in ipairs(vehicleHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

for _, hookType in ipairs(itemTransferHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

for _, hookType in ipairs(squareHooks) do
    SSS.Hooks[hookType] = SSS.Hooks[hookType] or {}
end

-- Handling lists
function SSS.Hooks:exist(hookType)
    return SSS.Hooks[hookType] and #SSS.Hooks[hookType] > 0
end

function SSS.Hooks:add(hookType, handler)
    if SSS.Hooks[hookType] then
        table.insert(SSS.Hooks[hookType], handler)
        SSS:log(SSS:getSCPrefix() .. 'Registering new hook of type ["' .. tostring(hookType) .. '"]')
        SSS:logStackTraceOrigin()
    end
end

function SSS.Hooks:get(hookType)
    return SSS.Hooks[hookType] or {}
end
