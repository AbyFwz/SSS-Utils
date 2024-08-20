require "SSS_Utils_Shared";

-- game mode detection

function SSS:gameIsSP()
	return isClient() == false;
end