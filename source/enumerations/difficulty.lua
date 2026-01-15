--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Enumeration = require("source.utilities.enumeration")

--< Difficulty:
local Difficulty = {
    --< Easy:
    VERY_EASY    =  Enumeration.new("VERY_EASY", 1);

    --< Easy:
    EASY         =  Enumeration.new("EASY", 2);

    --< Medium:
    MEDIUM       =  Enumeration.new("MEDIUM", 3);

    --< Medium:
    MEDIUM_HARD  =  Enumeration.new("MEDIUM_HARD", 4);

    --< Hard:
    HARD         =  Enumeration.new("HARD", 5);

    --< Hard:
    HARDER       =  Enumeration.new("HARDER", 6);

    --< Hard:
    VERY_HARD    =  Enumeration.new("VERY_HARD", 7);

    --< Cheat:
    CHEAT_VISION =  Enumeration.new("CHEAT_VISION", 8);

    --< Cheat:
    CHEAT_MONEY  =  Enumeration.new("CHEAT_MONEY", 9);

    --< Cheat:
    CHEAT_INSANE =  Enumeration.new("CHEAT_INSANE", 10);
}

--< Difficulty:
return Difficulty