--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Configuration:
local Configuration = require("source.configuration")

--< Enumerations:
local Difficulty = require("source.enumerations.difficulty")
local Player = require("source.enumerations.player")
local Status = require("source.enumerations.status")
local Race = require("source.enumerations.race")

--< Network:
local Protocol = require("source.network.protocol")
local Socket = require("source.network.socket")

--< Utilities:
local Logger = require("source.utilities.logger")

--< Coordinator:
local Coordinator = {
    --< Identier:
    identifier = 1;
}

--< Functions:
function Coordinator.send_and_receive(protocol, request)
    --< Validation:
    assert(protocol:send(request))

    --< Logic:
    return assert(protocol:receive())
end

function Coordinator.next_identifier()
    --< Variables (Assignment):
    --< Identifier:
    Coordinator.identifier = Coordinator.identifier + 1

    --< Logic:
    return Coordinator.identifier - 1
end

function Coordinator.run_game(map_path)
    --< Variables (Assignment):
    --< Socket:
    local socket = Socket.new()

    --< Initialization:
    assert(socket:initialize())

    --< Connection:
    assert(socket:connect())

    --< Protocol:
    local protocol = Protocol.new(socket, { debug = true })

    --< Creation:
    local creation_response = Coordinator.send_and_receive(protocol, {
        --< Identifier:
        identifier = Coordinator.next_identifier();

        --< Game:
        create_game = {
            --< Map:
            local_map = { map_path = map_path };

            --< Setup:
            player_setup = {
                --< Player:
                { type = Player.PARTICIPANT.value };

                --< Computer:
                { 
                    --< Type:
                    type = Player.COMPUTER.value;

                    --< Race:
                    race = Race.TERRAN.value;

                    --< Difficulty:
                    difficulty = Difficulty.CHEAT_INSANE.value
                }
            }
        }
    })

    --< Validation:
    if creation_response.create_game and creation_response.create_game.error then
        --< Logger:
        Logger.log_error("[!] create_game error: " .. tostring(creation_response.create_game.error ))

        --< Logic:
        return false
    end

    --< Join:
    local join_response = Coordinator.send_and_receive(protocol, {
        --< Identifier:
        id = Coordinator.next_identifier();

        --< Game:
        join_game = {
            --< Race:
            race = Configuration.RACE.value,

            --< Options:
            options = { raw = true };

            --< Name:
            player_name = Configuration.NAME;
        }
    })

    --< Validation:
    if join_response.join_game and join_response.join_game.error then
        --< Logger:
        Logger.log_error("[!] join_game error: " .. tostring(join_response.join_game.error ))

        --< Logic:
        return false
    end

    --< Logic:
    while true do
        --< Variables (Assignment):
        --< Response:
        local step_response = Coordinator.send_and_receive(protocol, {
            --< Identifier:
            id = Coordinator.next_identifier();

            --< Step:
            step = { count = 32 };
        })

        --< Validation:
        if step_response.status == Status.ENDED.value then
            break
        end

        --< Observation:
        local observation_response = Coordinator.send_and_receive(protocol, {
            --< Identifier:
            id = Coordinator.next_identifier();

            --< Observation:
            observation = {};
        })

        --< Validation:
        if observation_response.status == Status.ENDED.value then
            break
        end

        --< Validation:
        if observation_response.player_result and #observation_response.player_result > 0 then
            break
        end
    end

    return true
end

--< Coordinator:
return Coordinator