require "SSS_Utils_Shared"

-- Get the value of a field from an object
function SSS:getFieldValue(object, field)
    for i = 0, getNumClassFields(object) - 1 do
        local fld = getClassField(object, i)
        if fld and SSS:getStringFromLastOccurenceOfChar(fld, ".") == field then
            return getClassFieldVal(object, fld)
        end
    end
    return nil
end
