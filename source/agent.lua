--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Print = require("source.utilities.print")

--< Library:
local Matcher = require("source.library.matcher")

--< Core:
local Structures = require("source.core.structures")
local Structure = require("source.core.structure")

local Units = require("source.core.units")
local Unit = require("source.core.unit")

--< Agent:
local Agent = {}

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

		--< Townhalls:
		townhalls = nil;

		--< Workers:
		idle_worker_count = 0;
		workers = nil;

		--< Information:
		game_information = {};
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
	self.townhalls:train()
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

	--< Townhalls:
	self.townhalls = Structures.new(self.actions)

	--< Workers:
	self.idle_worker_count = observation.idle_worker_count
	self.workers = Units.new(self.actions)

	--< Internal:
	self:_populate_units(observation.raw_observation)
end

function Agent:_populate_information(raw_information)
	--< Variables (Assignment):
	--< Information:
	self.game_information = {
		--< Location:
		enemy_start_location = raw_information.game_info.start_raw.start_locations[1];

		--< Name:
		map_name = raw_information.game_info.map_name;

		--< Size:
		map_size = {
			--< Height:
			height = raw_information.game_info.start_raw.map_size.y;

			--< Width:
			width = raw_information.game_info.start_raw.map_size.x;
		}
	}
end

function Agent:_populate_units(raw_observation)
	for _, unit_information in pairs(raw_observation.observation.observation.raw_data.units) do
		--< Townhalls:
		if Matcher.is_townhall(unit_information.unit_type) then
			--< Logic:
			self.townhalls:append(Structure.new(unit_information, self.actions))

			--< Continue:
			goto continue
		end

		--< Worker:
		if Matcher.is_worker(unit_information.unit_type) then
			--< Logic:
			self.workers:append(Unit.new(unit_information, self.actions))

			--< Continue:
			goto continue
		end

		--< Continue:
		::continue::
	end
end

--< Agent:
Agent.__index = Agent
return Agent