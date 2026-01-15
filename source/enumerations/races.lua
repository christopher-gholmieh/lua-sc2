--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Enumeration = require("source.utilities.enumeration")

--< Races:
local Races = {
	--< Protoss:
	PROTOSS = Enumeration.new("PROTOSS", 1);

	--< Terran:
	TERRAN = Enumeration.new("TERRAN", 2);

	--< Zerg:
	ZERG = Enumeration.new("ZERG", 3);
}

--< Races:
return Races
