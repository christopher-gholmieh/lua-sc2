--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Logger = require("source.utilities.logger")

--< Structure:
local Structure = {}

--< Functions:
function Structure.new(structure_information, actions)
    --< Validation:
    if not actions then
        --< Logger:
        Logger.log_error("[!] Structure.new being called without the actions table supplied!")

        --< Logic:
        return nil
    end

    --< Variables (Assignment):
    --< Self:
    local Self = {
        --< Actions:
        actions = actions;

        --< Tag:
        tag = structure_information.tag;
    }

    --< Logic:
    setmetatable(Self, Structure)

    --< Self:
    return Self
end

--< Methods:
function Structure:attack()

end

function Structure:move(position)
    --< Validation:
    if not position then
        --< Logger:
        Logger.log_warning("[!] Structure.move is being called without any position!")

        --< Logic:
        return nil
    end

    --< Logic:
    table.insert(self.actions, {
        --< Action:
        action_raw = {
            --< Command:
            Structure_command = {
                --< Identifier:
                ability_id = 16;

                --< Tags:
                Structure_tags = { self.tag };

                --< Position:
                target_world_space_pos = { x = position.x, y = position.y };
            }
        }
    })
end

--< Logic:
Structure.__index = Structure
return Structure