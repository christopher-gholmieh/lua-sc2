--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Logger = require("source.utilities.logger")

--< Unit:
local Unit = {}

--< Functions:
function Unit.new(unit_information, actions)
    --< Validation:
    if not actions then
        --< Logger:
        Logger.log_error("[!] Unit.new being called without the actions table supplied!")

        --< Logic:
        return nil
    end

    --< Variables (Assignment):
    --< Self:
    local Self = {
        --< Actions:
        actions = actions;

        --< Tag:
        tag = unit_information.tag;
    }

    --< Logic:
    setmetatable(Self, Unit)

    --< Self:
    return Self
end

--< Methods:
function Unit:attack()

end

function Unit:move(position)
    --< Validation:
    if not position then
        --< Logger:
        Logger.log_warning("[!] Unit.move is being called without any position!")

        --< Logic:
        return nil
    end

    --< Logic:
    table.insert(self.actions, {
        --< Action:
        action_raw = {
            --< Command:
            unit_command = {
                --< Identifier:
                ability_id = 16;

                --< Tags:
                unit_tags = { self.tag };

                --< Position:
                target_world_space_pos = { x = position.x, y = position.y };
            }
        }
    })
end

--< Logic:
Unit.__index = Unit
return Unit