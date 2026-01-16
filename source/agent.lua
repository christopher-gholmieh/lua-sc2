--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Agent:
local Agent = {}

--< Functions:
function Agent.new()
	--< Variables (Assignment):
	--< Self:
	local Self = {
		--< Iteration:
		iteration = 0;

		--< Minerals:
		minerals = 50;

		--< Vespene:
		vespene = 0;

		--< Supply:
		supply_workers = 12;
		supply_army = 0;

		supply_cap = 15;
		supply = 12;

		--< Workers:
		idle_worker_count = 0;

		--< Actions:
		actions = {};
	}

	--< Logic:
	setmetatable(Self, Agent)

	--< Agent:
	return Agent
end

--< Methods:
function Agent:on_start()

end

function Agent:on_step()

end

function Agent:on_end()

end

--< Internal:
function Agent:_update(observation)
	--< Iteration:
	self.iteration = observation.iteration

	--< Minerals:
	self.minerals = observation.minerals

	--< Vespene:
	self.vespene = observation.vespene

	--< Supply:
	self.supply_workers = observation.supply_workers
	self.supply_army = observation.supply_army

	self.supply_cap = observation.supply_cap
	self.supply = observation.supply

	--< Workers:
	self.idle_worker_count = observation.idle_worker_count

	--< Actions:
	self.actions = {}
end

--< Agent:
return Agent