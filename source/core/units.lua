--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Logger = require("source.utilities.logger")

--< Units:
local Units = {}

--< Functions:
function Units.new(actions)
    if not actions then
        --< Logger:
        Logger.log_error("[!] Units.new being called without the actions table supplied!")

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
    setmetatable(Self, Units)

    --< Self:
    return Self
end

--< Methods:
function Units:append(unit)
    --< Validation:
    if self.collection[unit.tag] then
        return
    end

    --< Logic:
    self.collection[unit.tag] = unit;
end

function Units:attack(position)
    --< Variables (Assignment):
    --< Action:
    local action = {
        --< Action:
        action_raw = {
            --< Command:
            unit_command = {
                --< Identifier:
                ability_id = 3674;

                --< Tags:
                unit_tags = {};

                --< Position:
                target_world_space_pos = { x = position.x, y = position.y };
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

function Units:move(position)
    --< Validation:
    if not position then
        --< Logger:
        Logger.log_warning("[!] Units.move is being called without any position!")

        --< Logic:
        return nil
    end

    --< Variables (Assignment):
    --< Action:
    local action = {
        --< Action:
        action_raw = {
            --< Command:
            unit_command = {
                --< Identifier:
                ability_id = 16;

                --< Tags:
                unit_tags = {};

                --< Position:
                target_world_space_pos = { x = position.x, y = position.y };
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

    --< Logic:
    table.insert(self.actions, action)
end

--< Units:
Units.__index = Units
return Units