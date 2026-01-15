--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Enumerations:
local Races = require("source.enumerations.race")

--< Configuration:
local Configuration = {
	--< StarCraft II:
	--< Race:
	RACE = Races.TERRAN;

	--< Name:
	NAME = "Bot";


	--< Network:
	--< Host:
	HOST = "127.0.0.1";

	--< Port:
	PORT = 5000;
}

--< Configuration:
return Configuration