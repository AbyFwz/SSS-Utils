require "SSS_Utils_Client"

-- Get the closest vehicle to the player
function SSS:getClosestVehicle(player)
    player = player or SSS:getPlayer()
    local vehicle = player:getVehicle() or SSS.lastVehicle or ISVehicleMenu.getVehicleToInteractWith(player)
    return vehicle
end

-- Get the display name of a vehicle
function SSS:getVehicleName(vehicle)
    return ISVehicleMenu.getVehicleDisplayName(vehicle)
end
