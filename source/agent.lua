--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Agent:
local Agent = {}

--< Functions:
function Agent.new()
	--< Variables (Assignment):
	--< Self:
	local Self = {
		--< Minerals:
		minerals = 0;

		--< Vespene:
		vespene = 0;
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
end

--< Agent:
return Agent