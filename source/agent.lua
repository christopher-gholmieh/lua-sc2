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
		Minerals = 0;

		--< Vespene:
		Vespene = 0;
	}

	--< Logic:
	setmetatable(Self, Agent)

	--< Agent:
	return Agent
end

--< Methods:
function Agent:on_start()

end

function Agent:on_step(iteration)

end

function Agent:on_end()

end

--< Agent:
return Agent