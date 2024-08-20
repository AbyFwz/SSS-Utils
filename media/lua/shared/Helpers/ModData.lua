require "SSS_Utils_Shared"

-- Function to save mod data and optionally print values
function SSS:saveModData(object, printValues)
    object:transmitModData()
    if printValues then
        SSS:printModData(object)
    end
end

-- Function to print mod data
function SSS:printModData(object)
    if object then
        for k, v in pairs(object:getModData() or {}) do
            print(string.format("%s = %s", tostring(k), tostring(v)))
        end
    end
end
