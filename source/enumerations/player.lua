--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Enumeration = require("source.utilities.enumeration")

--< Player:
local Player = {
    --< Participant:
	PARTICIPANT 		= Enumeration.new("PARTICIPANT", 1);

    --< Computer:
	COMPUTER 		    = Enumeration.new("COMPUTER", 2);

	--< Observer:
	OBSERVER 	        = Enumeration.new("OBSERVER", 3);
}

--< Player:
return Player