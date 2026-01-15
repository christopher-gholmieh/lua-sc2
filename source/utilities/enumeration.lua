--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Enumeration:
local Enumeration = {}

--< Functions:
function Enumeration.new(name, value)
	--< Variables (Assignment):
	--< Self:
	local Self = {
		--< Name:
		name = name;

		--< Value:
		value = value;
	}

	--< Logic:
	setmetatable(Self, Enumeration)

	--< Self:
	return Self
end

--< Methods:
function Enumeration:__eq(enumeration)
	return (
		--< Value:
		self.value == enumeration.value and

		--< Name:
		self.name == enumeration.name
	)
end

--< Enumeration:
Enumeration.__index = Enumeration
return Enumeration
