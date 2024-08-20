require "SSS_Utils_Shared"

-- Function to get a sandbox variable with fallback
function SSS:getSandboxVar(name)
    local value = SandboxVars.SSS and SandboxVars.SSS[name] or SandboxVars.SSS and SandboxVars.SSS[name]
    return value or SSS.SandboxDefaults[name]
end

-- Function to read all defaults for a namespace
function SSS:getSandboxNamespaceDefaults(namespace)
    local sandboxOptions = getSandboxOptions()
    local result = {}

    for var in pairs(SandboxVars[namespace] or {}) do
        local value = sandboxOptions:getOptionByName(namespace .. "." .. var):getDefaultValue()
        result[var] = value
    end

    return result
end

-- Helper function to split a sandbox variable
function SSS:splitSandboxVar(name, separator)
    return SSS:splitString(SSS:getSandboxVar(name) or "", separator or ";") or {}
end

-- Helper function to split key-value sandbox variable into groups
function SSS:splitKVSandboxVarIntoGroups(name, entrySeparator)
    local result = {}

    for _, keyAndValue in ipairs(SSS:splitSandboxVar(name, entrySeparator)) do
        local split = SSS:splitString(keyAndValue, ":")
        result[split[1]] = split[2]
    end

    return result
end

-- Helper function to split key-value sandbox variable and get value by key
function SSS:splitKVSandboxVarAndGetByKey(name, key, entrySeparator)
    for _, keyAndValue in ipairs(SSS:splitSandboxVar(name, entrySeparator)) do
        local split = SSS:splitString(keyAndValue, ":")
        if split[1] == key then
            return split[2]
        end
    end

    return nil
end
