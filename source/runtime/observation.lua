--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Observation:
local Observation = {}

--< Functions:
function Observation.construct_observation(observation_response)
    --< Variables (Assignment):
    --< Information:
    local information = observation_response.observation.observation

    --< Self:
    local Self = {
        --< Iteration:
        iteration = information.game_loop;

        --< Minerals:
        minerals = information.player_common.minerals;

        --< Vespene:
        vespene = information.player_common.vespene;

        --< Supply:
        supply_workers = information.player_common.food_workers;
        supply_army = information.player_common.food_army;

        supply_cap = information.player_common.food_cap;
        supply = information.player_common.food_used;

        --< Workers:
        idle_worker_count = information.player_common.idle_worker_count;
    }

    --< Self:
    return Self
end

--< Observation:
return Observation