require "SSS_Utils_Shared"

-- Function to round a number to a specified number of decimal places
function SSS:roundNumber(number, decimals)
    decimals = decimals or 2
    return tonumber(string.format("%." .. decimals .. "f", number))
end

-- Function to round a number to two decimal places for currency
function SSS:roundCurrency(number)
    return string.format("%.2f", number)
end

-- Function to subtract a percentage from a number
function SSS:subtractPercentage(number, percentage)
    return percentage ~= 100 and number * (1 - (percentage / 100)) or 0
end

-- Function to get a percentage of a number
function SSS:getPercentageOf(number, percentage)
    return percentage ~= 100 and number * (percentage / 100) or number
end
