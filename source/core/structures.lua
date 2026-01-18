--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Identifiers:
local ABILITY_IDENTIFIER = require("source.identifiers.ability_id")

--< Utilities:
local Logger = require("source.utilities.logger")

--< Structures:
local Structures = {}

--< Functions:
function Structures.new(actions)
    if not actions then
        --< Logger:
        Logger.log_error("[!] Structures.new being called without the actions table supplied!")

        --< Logic:
        return nil
    end

    --< Variables (Assignment):
    --< Self:
    local Self = {
        --< Collection:
        collection = {};

        --< Actions:
        actions = actions;
    }

    --< Logic:
    setmetatable(Self, Structures)

    --< Self:
    return Self
end

--< Methods:
function Structures:append(unit)
    --< Validation:
    if self.collection[unit.tag] then
        return
    end

    --< Logic:
    self.collection[unit.tag] = unit;
end

function Structures:train(unit_type_identifier)
    --< Variables (Assignment):
    --< Action:
    local action = {
        --< Action:
        action_raw = {
            --< Command:
            unit_command = {
                --< Identifier:
                ability_id = ABILITY_IDENTIFIER.COMMANDCENTERTRAIN_SCV.value;

                --< Tags:
                unit_tags = {};
            }
        }
    }

    --< Logic:
    for tag, _ in pairs(self.collection) do
        table.insert(action.action_raw.unit_command.unit_tags, tag)
    end

    --< Validation:
    if #action.action_raw.unit_command.unit_tags == 0 then
        return nil
    end

    --< Action:
    table.insert(self.actions, action)
end

--< Structures:
Structures.__index = Structures
return Structures