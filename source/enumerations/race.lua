--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Enumeration = require("source.utilities.enumeration")

--< Race:
local Race = {
	--< Terran:
	TERRAN 		= Enumeration.new("TERRAN", 1);

	--< Zerg:
	ZERG 		= Enumeration.new("ZERG", 2);

	--< Protoss:
	PROTOSS 	= Enumeration.new("PROTOSS", 3);

	--< Random:
	RANDOM 		= Enumeration.new("RANDOM", 4);
}

--< Race:
return Race