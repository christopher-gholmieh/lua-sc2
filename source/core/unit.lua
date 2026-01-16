--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Unit:
local Unit = {}

--< Functions:
function Unit.new(unit_information)
    --< Variables (Assignment):
    --< Self:
    local Self = {}

    --< Logic:
    setmetatable(Self, Unit)

    --< Self:
    return Self
end

--< Methods:
function Unit:attack()

end

function Unit:move()
    
end

--< Logic:
Unit.__index = Unit
return Unit