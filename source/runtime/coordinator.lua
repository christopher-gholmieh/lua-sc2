--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Configuration:
local Configuration = require("source.configuration")

--< Enumerations:
local Difficulty = require("source.enumerations.difficulty")
local Player = require("source.enumerations.player")
local Status = require("source.enumerations.status")
local Race = require("source.enumerations.race")

--< Runtime:
local Observation = require("source.runtime.observation")

--< Network:
local Protocol = require("source.network.protocol")
local Socket = require("source.network.socket")

--< Utilities:
local Logger = require("source.utilities.logger")
local Print = require("source.utilities.print")

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

function Coordinator.run_game(map_path, agent)
    --< Validation:
    if not map_path then
        --< Logger:
        Logger.log_error("[!] Map path supplied to run_game is nil!")

        --< Logic:
        return
    end

    if not agent then
         --< Logger:
        Logger.log_error("[!] Agent supplied to run_game is nil!")

        --< Logic:
        return
    end

    --< Variables (Assignment):
    --< Socket:
    local socket = Socket.new()

    --< Initialization:
    assert(socket:initialize())

    --< Connection:
    assert(socket:connect())

    --< Protocol:
    local protocol = Protocol.new(socket, { debug = false })

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
                { 
                    --< Type:
                    type = Player.PARTICIPANT.value;
                };

                --< Computer:
                { 
                    --< Type:
                    type = Player.COMPUTER.value;

                    --< Race:
                    race = Race.TERRAN.value;

                    --< Difficulty:
                    difficulty = Difficulty.VERY_EASY.value
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
            options = {
                --< Raw:
                raw = true;

                --< Score:
                score = true;

                --< Cloaked:
                show_cloaked = true;

                --< Shadows:
                show_burrowed_shadows = true;

                --< Crop:
                raw_crop_to_playable_area = false;

                --< Placeholders:
                show_placeholders = true;
            };

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

    --< Information:
    local information_response = Coordinator.send_and_receive(protocol, {
        --< Identifier:
        id = Coordinator.next_identifier();

        --< Inforamtion:
        game_info = {};
    })

    --< Initialization:
    agent:_populate_information(information_response)

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

        --< Agent:
        agent:_update(Observation.construct_observation(observation_response))
        
        --< Agent:
        agent:on_step()

        --< Logic:
        if #agent.actions > 0 then
            --< Variables (Assignment):
            --< Action:
            local action_response = Coordinator.send_and_receive(protocol, {
                --< Identifier:
                id = Coordinator.next_identifier();

                --< Action:
                action = {
                    --< Actions:
                    actions = agent.actions;
                }
            })
        end
    end

    return true
end

--< Coordinator:
return Coordinator