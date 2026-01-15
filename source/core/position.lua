--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Position:
local Position = {}

--< Functions:
function Position.new(x_coordinate, y_coordinate, z_coordinate)
	--< Variables (Assignment):
	--< Self:
	local Self = {
		--< X:
		x_coordinate = x_coordinate;

		--< Y:
		y_coordinate = y_coordinate;

		--< Z:
		z_coordinate = z_coordinate or 0;
	}

	--< Logic:
	setmetatable(Self, Position)

	--< Self:
	return Self
end

--< Methods:
function Position:distance_to(position)
	--< Variables (Assignment):
	--< Distance:
	local distance = math.sqrt(
		(self.x_coordinate - position.x_coordinate) ^ 2 +
		(self.y_coordinate - position.y_coordinate) ^ 2 +
		(self.z_coordinate - position.z_coordinate) ^ 2
	)

	--< Distance:
	return distance
end

function Position:__mul(factor)
	return Position.new(
		self.x_coordinate * factor,
		self.y_coordinate * factor,
		self.z_coordinate * factor
	)
end

function Position:__div(factor)
	return Position.new(
		self.x_coordinate / factor,
		self.y_coordinate / factor,
		self.z_coordinate / factor
	)
end

function Position:__add(position)
	return Position.new(
		self.x_coordinate + position.x_coordinate,
		self.y_coordinate + position.y_coordinate,
		self.z_coordinate + position.z_coordinate
	)
end

function Position:__sub(position)
	return Position.new(
		self.x_coordinate - position.x_coordinate,
		self.y_coordinate - position.y_coordinate,
		self.z_coordinate - position.z_coordinate
	)
end

function Position:__tostring()
	return string.format(
		--< Buffer:
		"Position {X: %.2f, Y: %.2f, Z: %.2f}",

		--< X:
		self.x_coordinate,

		--< Y:
		self.y_coordinate,

		--< Z:
		self.z_coordinate
	)
end

--< Position:
Position.__index = Position
return Position
