--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Print = require("source.utilities.print")

--< Core:
local Units = require("source.core.units")
local Unit = require("source.core.unit")

--< Agent:
local Agent = {}

--< Constants:
local TERRAN_SCV_UNIT_TYPE = 45

--< Functions:
function Agent.new()
	--< Variables (Assignment):
	--< Self:
	local Self = {
		--< Iteration:
		iteration = 0;

		--< Actions:
		actions = {};

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
		workers = nil;
	}

	--< Logic:
	setmetatable(Self, Agent)

	--< Agent:
	return Self
end

--< Methods:
function Agent:on_start()

end

function Agent:on_step()
	self.workers:move({ x = 45.5, y = 12.0 })
end

function Agent:on_end()

end

--< Internal:
function Agent:_update(observation)
	--< Iteration:
	self.iteration = observation.iteration

	--< Actions:
	self.actions = {}

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
	self.workers = Units.new(self.actions)

	--< Internal:
	self:_populate_units(observation.raw_observation)
end

function Agent:_populate_units(raw_observation)
	for _, unit_information in pairs(raw_observation.observation.observation.raw_data.units) do
		if unit_information.unit_type == TERRAN_SCV_UNIT_TYPE then
			self.workers:append(Unit.new(unit_information, self.actions))
		end
	end
end

--< Agent:
Agent.__index = Agent
return Agent