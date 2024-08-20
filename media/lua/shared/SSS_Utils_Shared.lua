-- Main initialization
SSS = SSS or {}

-- Default settings and variables
local defaults = {
    speechR = 255 / 255,
    speechG = 87 / 255,
    speechB = 87 / 255,
    textR = 1,
    textG = 1,
    textB = 1,
    stringArrayDivider = "||",
    lastErrorObj = nil,
    lastUsedVehicle = nil,
    lastExecObj = nil,
    currentPlayer = nil,
    debugSay = false,
    onlinePlayersCache = {},
    findTranslationExp = "(IGUI%_[%_%w]+)",
    findTimestampExp = {
        "% %(%[%,[%,%]%)% ]", -- within certain chars
        "^(1%d%d%d%d%d%d%d%d%d%d%d%d)[%,%]%)% ]", -- at start with chars following
        "% %(%[%,$", -- after certain chars before end
        "^(1%d%d%d%d%d%d%d%d%d%d%d%d)$", -- full string
    },
}

for k, v in pairs(defaults) do
    SSS[k] = v
end

-- Sandbox defaults for fallback
SSS.SandboxDefaults = {}

-- Other namespaces
SSS.Commands = SSS.Commands or {}
SSS.Files = SSS.Files or {}
SSS.Paths = SSS.Paths or {}
SSS.Icons = SSS.Icons or {}

SSS.Files.debugLog = "SSS_debug.log"
SSS.Files.errorLog = "SSS_error.log"
SSS.Files.migrationLog = "SSS_misc/migration.log"

SSS.Icons.SSS = "media/ui/SSS_icon.png"

SSS.Paths.tileProtect = "SSS_tile_protect/"

SSS.Files.movSledgeBreakLog = SSS.Paths.tileProtect .. "sledge_broken.log"
SSS.Files.movWhitelistDestroyLog = SSS.Paths.tileProtect .. "whitelist_destruction.log"

-- Get sandbox defaults for fallback
Events.OnGameStart.Add(function()
    SSS.SandboxDefaults = SSS:mergeArrays(SSS.SandboxDefaults, SSS:getSandboxNamespaceDefaults("SSS"))
    SSS.SandboxDefaults = SSS:mergeArrays(SSS.SandboxDefaults, SSS:getSandboxNamespaceDefaults("SSS"))
end)

Events.OnGameBoot.Add(function()
    SSS.Hooks:add("objectIsProtected", function(object, mode, spriteName, source)
        if SSS:getSandboxVar("MakeMDContainersUnbreakable") and SSS.Movables:objectHasContainerModData(object) then
            return true
        end
    end)

    SSS.Hooks:add("eachObjectOnSquareLoad", function(object, square, modData)
        if modData.indestructible or (SSS:getSandboxVar("MakeMDContainersUnbreakable") and SSS.Movables:objectHasContainerModData(object, modData)) then
            SSS.Movables:setUnbreakable(object, true, false)
        end
    end)
end)
