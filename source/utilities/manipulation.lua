--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Manipulation:
local Manipulation = {}

--< Functions:
function Manipulation.mask_payload(payload, mask)
    --< Variables (Assignment):
    --< Output:
    local output = {}

    --< Logic:
    for iterator = 1, #payload do
        --< Variables (Assignment):
        --< Byte:
        local byte = payload:byte(iterator)

        --< Mask:
        local byte_mask = mask:byte(((iterator - 1) % 4) + 1)

        --< Logic:
        output[iterator] = string.char(byte ~ byte_mask)
    end

    --< Output:
    return table.concat(output)
end

--< Manipulation:
return Manipulation
