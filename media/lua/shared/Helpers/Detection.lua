require "SSS_Utils_Client";

function SSS:chatIsEnabled()
    return getActivatedMods():contains("SSS_Chat");
end

function SSS:tileProtectionIsEnabled()
    return getActivatedMods():contains("SSS_TileProtect");
end