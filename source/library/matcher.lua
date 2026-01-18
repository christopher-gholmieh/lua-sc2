--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Identifiers:
local UNIT_IDENTIFIER = require("source.identifiers.unit_typeid")

--< Matcher:
local Matcher = {
    --< Townhalls:
    TOWNHALL_TAGS = {
        --< Center:
        [UNIT_IDENTIFIER.COMMANDCENTER.value] = true;

        --< Hatchery:
        [UNIT_IDENTIFIER.HATCHERY.value] = true;

        --< Nexus:
        [UNIT_IDENTIFIER.NEXUS.value] = true;
    };

    --< Workers:
    WORKER_TAGS = {
        --< Probe:
        [UNIT_IDENTIFIER.PROBE.value] = true;

        --< Drone:
        [UNIT_IDENTIFIER.DRONE.value] = true;

        --< SCV:
        [UNIT_IDENTIFIER.SCV.value] = true;
    };
}

--< Functions:
function Matcher.is_townhall(unit_type_identifier)
    return Matcher.TOWNHALL_TAGS[unit_type_identifier]
end

function Matcher.is_worker(unit_type_identifier)
    return Matcher.WORKER_TAGS[unit_type_identifier]
end

--< Logic:
return Matcher