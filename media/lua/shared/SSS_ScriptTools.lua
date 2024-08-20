SSS = SSS or {}
SSS.ScriptTools = SSS.ScriptTools or {}

SSS.ScriptTools.loadedFiles = {}

function SSS.ScriptTools:loadScriptInModFolder(modId, fileName)
    local loadedFiles = SSS.ScriptTools.loadedFiles
    loadedFiles[modId] = loadedFiles[modId] or {}

    if not string.find(fileName, "media/") then
        fileName = "media/" .. fileName
    end

    if not loadedFiles[modId][fileName] then
        local modInfo = getModInfoByID(modId)

        if modInfo then
            loadedFiles[modId][fileName] = true

            fileName = modInfo:getDir() .. "/" .. fileName
            fileName = string.gsub(fileName, "[%/%\\]", getFileSeparator())

            getScriptManager():LoadFile(fileName, true)

            return true
        end
    end

    return false
end

function SSS.ScriptTools:loadScriptIfModEnabled(scriptModId, fileName, mod)
    local enabledMods = getActivatedMods()

    for _, modId in ipairs(SSS:tableIfNotTable(mod)) do
        if enabledMods:contains(modId) then
            return SSS.ScriptTools:loadScriptInModFolder(scriptModId, fileName)
        end
    end

    return false
end
